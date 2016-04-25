//
//  SponsorViewController.swift
//  DonateTheDistance
//
//  Created by MU IT Program on 2/1/16.
//  Copyright © 2016 Brooke Haile-Mariam. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class SponsorViewController: UIViewController {

    var charity:Charity = Charity(name: "", description: "", iconName: "")
    var workoutType:WorkoutType!
    var locations = [CLLocation]()
    var run:Run!
    
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var sponsorLabel: UILabel!
    @IBOutlet weak var sponsorIcon: UIImageView!
    
    let sponsorNames: [String] = ["Johnson and Johnson", "Google", "Chobani", "Target"]
    let sponsorIconNames: [String] = ["JohnsonAndJohnson.png", "Google.png", "Chobani.jpg", "Target.jpeg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let randomInt = Int(arc4random_uniform(4))
        sponsorLabel.text = sponsorNames[randomInt]
        sponsorIcon.image = UIImage(named: sponsorIconNames[randomInt])
        self.view.backgroundColor = UIColor(netHex: 0x636466)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "showWorkoutResults", userInfo: nil, repeats: false)
    }
    
    func showWorkoutResults() {
        self.performSegueWithIdentifier("toWorkoutResults", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! WorkoutResultsViewController
        destinationViewController.workoutType = workoutType
        destinationViewController.sponsor = sponsorLabel.text
        destinationViewController.charity = charity.name
        destinationViewController.locations = locations
        destinationViewController.run = run
    }

}
