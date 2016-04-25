//
//  Walk.swift
//  DonateTheDistance
//
//  Created by Brendon Sexe on 4/25/16.
//  Copyright © 2016 Brooke Haile-Mariam. All rights reserved.
//

import UIKit
import CoreMotion

class Walk: UIViewController {

    @IBOutlet weak var steps: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var calories: UILabel!
    var archiver = Run()
    var userArchiver = UserData()
    var step:Double = 0.0
    let walkRatio = 0.53
    var caloriesBurned:Double = 0.0
    var caloriesBurnedPerMile:Double = 0.0
    var donationAmount:Double = 0
    var distanceTraveled:Double = 0.0
    var numSteps: NSNumber = 500
    var moneyString: String = ""
    var distanceString: String = ""
    var caloriesString: String = ""
    var stepString: String = ""
    var stepsDouble: Double = 0.0
    var stop: Bool = false
    
    let pedometer = CMPedometer()
    
     override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(netHex: 0x636466)
        if let user = loadUser() {
            let height = user.height
            step = Double(height) * 0.413
            caloriesBurnedPerMile = 0.53 * Double(user.weight)
        }
        
    self.pedometer.startPedometerUpdatesFromDate(NSDate()) { (data, error) -> Void in
        if(error == nil){
            self.numSteps = data!.numberOfSteps
            self.stepString = String(format: "%f", self.numSteps)
            self.steps.text = self.stepString
        }else{
            self.stop = true;
        }
            
        }
        if(stop == true){
        stepsDouble = Double(stepString)!
        distanceTraveled = (stepsDouble * step)/63360
        donationAmount = 0.25 * distanceTraveled
        caloriesBurned = caloriesBurnedPerMile * distanceTraveled
        moneyString = String(format: "%f", donationAmount)
        money.text = moneyString
        distanceString = String(format: "%f", distanceTraveled)
        distance.text = distanceString
        caloriesString = String(format: "%f", caloriesBurned)
        calories.text = caloriesString}
        
        
       // distanceTraveled = numSteps * step
    }
        
    @IBAction func stopWorkout(sender: AnyObject) {
        self.pedometer.stopPedometerUpdates()
        //run = Run(distance: (distance*0.00062137), Duration: steps, calories: calories, donationAmount: donationAmount)
        if(stop == true){
        let run : Run = Run(distance: distanceTraveled, duration: stepsDouble, calories: caloriesBurned, donationAmount: donationAmount)
        //archiver.add(run)
            archiver.saveWorkout(run)}
        print("it sent stuff")
        
    }
        func loadUser() -> UserData? {
            return NSKeyedUnarchiver.unarchiveObjectWithFile(UserData.ArchiveURL.path!) as? UserData
        }
    

}
