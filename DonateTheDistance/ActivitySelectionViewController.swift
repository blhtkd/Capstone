//
//  ActivitySelectionViewController.swift
//  DonateTheDistance
//
//  Created by Brooke Haile-Mariam on 12/21/15.
//  Copyright © 2015 Brooke Haile-Mariam. All rights reserved.
//

import UIKit

class ActivitySelectionViewController: UIViewController {

    var charity:Charity = Charity(name: "", description: "", iconName: "");
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var charityDetailButton: UIButton!
    var workoutType:WorkoutType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(netHex: 0x636466)
        charityDetailButton.setTitle(charity.name, forState: UIControlState.Normal)
        imageView.image = UIImage(named: charity.iconName)
    }

    @IBAction func showCharityDetail(sender: AnyObject) {
        
        performSegueWithIdentifier("toCharityDetail", sender: self)
    }
    
    @IBAction func walkButton(sender: AnyObject) {
        workoutType = WorkoutType.Walk
        performSegueWithIdentifier("toWorkout", sender: self)
    }
    
    @IBAction func runButton(sender: AnyObject) {
        workoutType = WorkoutType.Run
        performSegueWithIdentifier("toWorkout", sender: self)
        
    }
    
    @IBAction func bikeButton(sender: AnyObject) {
        workoutType = WorkoutType.Bike
        performSegueWithIdentifier("toWorkout", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toCharityDetail") {
            let destinationViewController = segue.destinationViewController as! CharityDetailViewController
            destinationViewController.charity = charity
        } else {
            let destinationViewController = segue.destinationViewController as! WorkoutViewController
            destinationViewController.charity = charity
            destinationViewController.workoutType = workoutType
        }
    }
}
