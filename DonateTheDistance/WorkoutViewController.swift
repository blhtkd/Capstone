//
//  WorkoutViewController.swift
//  DonateTheDistance
//
//  Created by MU IT Program on 2/1/16.
//  Copyright © 2016 Brooke Haile-Mariam. All rights reserved.
//

import CoreLocation
import HealthKit
import UIKit
import CoreData
import MapKit
import CoreMotion

class WorkoutViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    internal var charity:Charity = Charity(name: "", description: "", iconName: "")
    var workoutType:WorkoutType!
    
    //Tracks the duration of the run, in seconds
    var seconds = 0.0
    //Holds the cumulative distance of the run, in miles
    var distance = 0.0
    
    var managedObjectContext: NSManagedObjectContext?
    
    var run: Run!
    var savedLocations = [NSManagedObject]()
    var archiver = Run()
    var userArchiver = UserData()
    var step:Double = 0.0
    
    let pedoMeter = CMPedometer()
    let activityManager = CMMotionActivityManager()
    
    //Ratio used to calculate calories based on person's weight
    let walkRatio = 0.53
    let runRatio = 0.75
    let bikeRatio = 0.3
    
    var calories:Double = 0.0
    var donationAmount:Double = 0
    
    typealias CMPedometerHandler = (CMPedometerData?, NSError?) -> Void
    
    //The object you’ll tell to start or stop reading the user’s location
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        //Tracks the best and most precise location readings
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //Intelligently helps the device save power throughout a user’s run (if they stop)
        _locationManager.activityType = .Fitness
        
        // Movement threshold for new events
        _locationManager.distanceFilter = 10.0
        
        _locationManager.allowsBackgroundLocationUpdates = true
        
        return _locationManager
    }()
    
    //An array to hold all the Location objects that will roll in
    lazy var locations = [CLLocation]()
    
    //Will fire each second and update the UI accordingly
    lazy var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(netHex: 0x636466)
        calculateSteps()
        //self.pedoMeter.startPedometerUpdatesFromDate(NSDate(), withHandler: CMPedometerHandler)
        
        if(CMMotionActivityManager.isActivityAvailable()){
            print("YESS!")
            self.activityManager.startActivityUpdatesToQueue(NSOperationQueue.mainQueue()) { data in
                if let data = data {
                    dispatch_async(dispatch_get_main_queue()) {
                        if(data.stationary == true){
                            //self.activityState.text = "Stationary"
                        } else if (data.walking == true){
                            //self.activityState.text = "Walking"
                        } else if (data.running == true){
                            //self.activityState.text = "Running"
                        } else if (data.automotive == true){
                            //self.activityState.text = "Automotive"
                        }
                    }
                }
            }
        }
        /*var comps = cal.components(MonthCalendarUnit | .DayCalendarUnit | .HourCalendarUnit | .MinuteCalendarUnit | .SecondCalendarUnit, fromDate: NSDate())
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        let timeZone = NSTimeZone.systemTimeZone()
        cal.timeZone = timeZone
        
        let midnightOfToday = cal.dateFromComponents(comps)!
        
        if(CMPedometer.isStepCountingAvailable()){
            let fromDate = NSDate(timeIntervalSinceNow: -86400 * 7)
            self.pedoMeter.queryPedometerDataFromDate(fromDate, toDate: NSDate()) { (data : CMPedometerData!, error) -> Void in
                print(data)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if !(error){
                        self.paceLabel.text = "\(data.numberOfSteps)"
                    }
                })
                
            }
            
            self.pedoMeter.startPedometerUpdatesFromDate(midnightOfToday) { (data: CMPedometerData!, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(error == nil){
                        self.steps.text = "\(data.numberOfSteps)"
                    }
                })
            }
        }*/
        
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        self.view.insertSubview(mapView, atIndex: 0)
        //Request the location usage authorization from your users
        locationManager.requestAlwaysAuthorization()
        
        startButton.hidden = false
        stopButton.hidden = true
    }
    
    //The timer is stopped when the user navigates away from the view
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    func startLocationUpdates() {
        //The location manager will be lazily instantiated
        locationManager.startUpdatingLocation()
    }
    
    func calculateCalories() {
        //var calories:Double = 0.0
        let weight = Double(userArchiver.weight)
        if (workoutType == WorkoutType.Walk) {
            calories = weight * walkRatio * distance
        } else if (workoutType == WorkoutType.Run) {
            calories = weight * runRatio * distance
        } else if (workoutType == WorkoutType.Bike) {
            calories = weight * bikeRatio * distance
        }
        //run.calories = calories
    }
    
    func calculateSteps() {
        if let user = loadUser() {
            let height = user.height
            let heightCm = Double(height) * 2.54
            step = Double(heightCm) * 0.413
        }
    }
    
    // This method will be called every second, by using an NSTimer. Each time this method is called, you increment the second count and update each of the statistics labels accordingly.
    func eachSecond(timer: NSTimer) {
        seconds++
        let secondsQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: seconds)
        timeLabel.text = "Time: " + secondsQuantity.description
        
        if (workoutType == WorkoutType.Run || workoutType == WorkoutType.Bike) {
            let distanceQuantity = HKQuantity(unit: HKUnit.mileUnit(), doubleValue: (distance*0.00062137))
            distanceLabel.text = "Distance: " + distanceQuantity.description
            
            let paceUnit = HKUnit.minuteUnit().unitDividedByUnit(HKUnit.mileUnit())
            let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: (26.8224 / (distance / seconds)))
            paceLabel.text = "Pace: " + paceQuantity.description
        } else if (workoutType == WorkoutType.Walk) {
            let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: distance)
            distanceLabel.text = "Distance: " + distanceQuantity.description
            
            let stepCount = (distance*100) / step
            paceLabel.text = "Steps: " + stepCount.description
            //distanceLabel.hidden = true
        }
        
    }
    
    // This method will create a new run object and assign it cumulative values, each CLLocation objects recorded are trimmed down to Location, which is then linked to the run
    func saveRun() {
        calculateCalories()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("Run",
            inManagedObjectContext:managedContext)
        
        let savedRun = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        savedRun.setValue(distance, forKey: "distance")
        savedRun.setValue(seconds, forKey: "duration")
        savedRun.setValue(NSDate(), forKey: "timestamp")
        
        
        // Each of the CLLocation objects recorded during the run is trimmed down to a new Location object and saved. Then you link the locations to the Run
        
        for location in locations {
            let savedLocation = NSEntityDescription.insertNewObjectForEntityForName("Location",
                inManagedObjectContext: managedContext)
            savedLocation.setValue(location.timestamp, forKey: "timestamp")
            savedLocation.setValue(location.coordinate.latitude, forKey: "latitude")
            savedLocation.setValue(location.coordinate.longitude, forKey: "longitude")
            
            savedLocations.append(savedLocation)
        }
        
        //savedRun.locations = NSOrderedSet(array: savedLocations)
        
        //savedRun.setValue(NSOrderedSet(array: savedLocations), forKey: "location")
        
        for item in savedLocations {
            do { savedRun.setValue(item, forKey: "location")
                try managedContext.save()}
            catch {}
        }
        
        //run = savedRun
        
        // Complete save and handle potential error
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        //Calculate donation
        calculateDonation()
        
        run = Run(distance: (distance*0.00062137), duration: seconds, calories: calories, donationAmount: donationAmount)
        //archiver.add(run)
        archiver.saveWorkout(run)
    }
    
    // Calculates the amount of money donated to the charity based on the distance and type of workout the user completed
    func calculateDonation() {
        if (workoutType == WorkoutType.Walk) {
            donationAmount = distance * walkRatio
        } else if (workoutType == WorkoutType.Run) {
            donationAmount = distance * runRatio
        } else if (workoutType == WorkoutType.Bike) {
            donationAmount = distance * bikeRatio
        }
    }

    func loadUser() -> UserData? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(UserData.ArchiveURL.path!) as? UserData
    }
    
    @IBAction func startPressed(sender: AnyObject) {
        startButton.hidden = true
        stopButton.hidden = false
        
        timeLabel.hidden = false
        distanceLabel.hidden = false
        paceLabel.hidden = false
        
        seconds = 0.0
        distance = 0.0
        locations.removeAll(keepCapacity: false)
        timer = NSTimer.scheduledTimerWithTimeInterval(1,
            target: self,
            selector: "eachSecond:",
            userInfo: nil,
            repeats: true)
        startLocationUpdates()
        
        mapView.hidden = false
    }
    
    @IBAction func stopPressed(sender: AnyObject) {
        
        let refreshAlert = UIAlertController(title: "Refresh", message: "Workout finished.", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Save", style: .Default, handler: { (action: UIAlertAction!) in
            self.saveRun()
            
            self.performSegueWithIdentifier("toSponsor", sender: nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Discard", style: .Default, handler: { (action: UIAlertAction!) in
            self.performSegueWithIdentifier("toSponsor", sender: nil)
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! SponsorViewController
        destinationViewController.charity = charity
        destinationViewController.workoutType = workoutType
        destinationViewController.locations = locations
        destinationViewController.run = run
    }
    
    
    
}

//Class extension to conform to the CLLocationManagerDelegate protocol
extension WorkoutViewController: CLLocationManagerDelegate {
    
    //Method that is called each time there are new location updates to provide the app
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            let howRecent = location.timestamp.timeIntervalSinceNow
            
            if abs(howRecent) < 10 && location.horizontalAccuracy < 20 {
                //update distance
                if self.locations.count > 0 {
                    distance += location.distanceFromLocation(self.locations.last!)
                    
                    var coords = [CLLocationCoordinate2D]()
                    coords.append(self.locations.last!.coordinate)
                    coords.append(location.coordinate)
                    
                    let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
                    mapView.setRegion(region, animated: true)
                    
                    mapView.addOverlay(MKPolyline(coordinates: &coords, count: coords.count))
                }
                
                //save location
                self.locations.append(location)
            }
        }
    }
}

extension WorkoutViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        /*if !overlay.isKindOfClass(MKPolyline) {
            return nil
        }*/
        
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 3
        return renderer
    }
}
