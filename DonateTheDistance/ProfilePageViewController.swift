//
//  ProfilePageViewController.swift
//  DonateTheDistance
//
//  Created by MU IT Program on 2/1/16.
//  Copyright © 2016 Brooke Haile-Mariam. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var totalDistanceLabel: UILabel!
    @IBOutlet weak var totalDonatedLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var archiver = UserData()
    var workoutList = Run()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let user = loadUser() {
            nameLabel.text = "Name: " + user.firstName + " " + user.lastName
            heightLabel.text = "Height: " + user.height.description
            weightLabel.text = "Weight: " + user.weight.description
            registrationLabel.text = "Member since " + user.registrationDate.description
            
        }
        
        if let workout = workoutList.loadWorkout() {
            totalDistanceLabel.text = "Total distance: " + (round(workout.totalDistance * 1000) / 1000).description
            totalDonatedLabel.text = "Total donated: $45"
        }
        //workoutList.save()
        
        self.view.backgroundColor = UIColor(netHex: 0x636466)
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ProfileTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ProfileTableViewCell
        //cell.distanceLabel.text = workoutList[indexPath].distance
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.contentView.backgroundColor = UIColor(netHex: 0x636466)
    }
    
    func loadUser() -> UserData? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(UserData.ArchiveURL.path!) as? UserData
    }
    
    
}
