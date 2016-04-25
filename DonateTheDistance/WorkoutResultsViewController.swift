//
//  WorkoutResultsViewController.swift
//  DonateTheDistance
//
//  Created by MU IT Program on 2/1/16.
//  Copyright © 2016 Brooke Haile-Mariam. All rights reserved.
//

import UIKit
import HealthKit
import MapKit
import CoreData

class WorkoutResultsViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var donationLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    
    var run: Run!
    var workoutType:WorkoutType!
    var sponsor:String!
    var archiver = DonationData()
    var userArchiver = UserData()
    var charity:String!
    var locations = [CLLocation]()
    var steps:Int = 0
    
    //Amount donated per mile
    let walkRatio = 0.25
    let runRatio = 0.5
    let bikeRatio = 0.1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor(netHex: 0x636466)
        //loadRun()
        configureView()
    }
    
    // Sets up the details of the run and puts them in the labels
    func configureView() {
        let distanceQuantity = HKQuantity(unit: HKUnit.mileUnit(), doubleValue: run.distance)
        distanceLabel.text = "Distance: " + distanceQuantity.description
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateLabel.text = dateFormatter.stringFromDate(run.timestamp)
        
        let secondsQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: run.duration)
        timeLabel.text = "Time: " + secondsQuantity.description
        
        let paceUnit = HKUnit.minuteUnit().unitDividedByUnit(HKUnit.mileUnit())
        let speed = (run.distance / (run.duration / 360))
        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: (60 / speed))
        paceLabel.text = "Pace: " + paceQuantity.description
        
        caloriesLabel.text = "Calories: " + run.calories.description
        donationLabel.text = "Donation: " + (round(100*run.totalDonated)/100).description
        
        calculateDonation()
        loadMap()
    }
    
    // Calculates the amount of money donated to the charity based on the distance and type of workout the user completed
    func calculateDonation() {
        //Save running totals for the sponsors to donate
        if (sponsor == "Johnson And Johnson") {
            archiver.JohnsonAndJohnson += run.totalDonated
        } else if (sponsor == "Google") {
            archiver.Google += run.totalDonated
        } else if (sponsor == "Chobani") {
            archiver.Chobani += run.totalDonated
        } else if (sponsor == "Target") {
            archiver.Target += run.totalDonated
        }
        
        //Save running totals for the charities to collect
        if (charity == "The Humane Society") {
            archiver.HumaneSociety += run.totalDonated
        } else if (sponsor == "Charity: Water") {
            archiver.CharityWater += run.totalDonated
        } else if (sponsor == "Stand Up 2 Cancer") {
            archiver.StandUpToCancer += run.totalDonated
        } else if (sponsor == "Habitat for Humanity") {
            archiver.HabitatForHumanity += run.totalDonated
        }
        
        //userArchiver.totalDistance += run.distance
        //userArchiver.totalDonated += donationAmount
    }
    
    // Returns the MKCoordinateRegion of the run (An MKCoordinateRegion represents the display region for the map using a center point and a span that defines horizontal and vertical ranges)
    func mapRegion() -> MKCoordinateRegion {
        let initialLoc:CLLocation = locations[0]
        
        var minLat = initialLoc.coordinate.latitude
        var minLng = initialLoc.coordinate.longitude
        var maxLat = minLat
        var maxLng = minLng
        
        //let locationss = run.valueForKey("location") as! [NSManagedObject]
        
        for location in locations {
            minLat = min(minLat, location.coordinate.latitude)
            minLng = min(minLng, location.coordinate.longitude)
            maxLat = max(maxLat, location.coordinate.latitude)
            maxLng = max(maxLng, location.coordinate.longitude)
        }
        
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2,
                longitude: (minLng + maxLng)/2),
            span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*1.1,
                longitudeDelta: (maxLng - minLng)*1.1))
    }
    
    // Whenever the map comes across a request to add an overlay, it should check if it’s an MKPolyline
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if !overlay.isKindOfClass(MulticolorPolylineSegment) {
            return nil
        }
        
        let polyline = overlay as! MulticolorPolylineSegment
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = polyline.color
        renderer.lineWidth = 3
        return renderer
    }
    
    // Update the data from the Location objects into an array of CLLocationCoordinate2D, the required format for polylines
    func polyline() -> MKPolyline {
        var coords = [CLLocationCoordinate2D]()
        
        let locations = run.valueForKey("location") as! NSArray
        for location in locations {
            coords.append(CLLocationCoordinate2D(latitude: location.valueForKey("latitude") as! Double,
                longitude: location.valueForKey("longitude") as! Double))
        }
        
        return MKPolyline(coordinates: &coords, count: run.valueForKey("location")!.count)
    }
    
    // Check if there are points to draw, set the map region, and add the polyline overlay
    func loadMap() {
        if locations.count > 0 {
            mapView.hidden = false
            
            // Set the map bounds
            mapView.region = mapRegion()
            
            // Make the lines on the map
            let colorSegments = MulticolorPolylineSegment.colorSegments(forLocations: locations)
            mapView.addOverlays(colorSegments)
        } else {
            // No locations were found!
            mapView.hidden = true
            //******can add an alert later
            //print("no locations")
        }
    }
    
   
    
    @IBAction func toProfile(sender: AnyObject) {
        performSegueWithIdentifier("toProfile", sender: self)
        
    }
}
