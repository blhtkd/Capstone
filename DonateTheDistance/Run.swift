//
//  Run.swift
//  DonateTheDistance
//
//  Created by MU IT Program on 4/23/16.
//  Copyright © 2016 Brooke Haile-Mariam. All rights reserved.
//

import UIKit
import CoreData

class Run: NSObject, NSCoding {
    // MARK: Properties
    var distance:Double!
    var duration:Double!
    var timestamp:NSDate!
    var calories:Double!
    var totalDistance = 0.0
    var totalDonated = 0.0
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("run")
    
    // MARK: Initialization
    init(distance: Double, duration: Double, calories: Double, donationAmount: Double) {
        self.distance = distance
        self.duration = duration
        self.calories = calories
        self.timestamp = NSDate()
        self.totalDistance += distance
        self.totalDonated += donationAmount
    }
    
    override init(){}
    
    var workoutArray = [Run]()
    
    // MARK: NSCoding
    required init(coder aDecoder: NSCoder) {
        self.distance = aDecoder.decodeDoubleForKey("distance")
        self.duration = aDecoder.decodeDoubleForKey("duration")
        self.calories = aDecoder.decodeDoubleForKey("calories")
        self.timestamp = aDecoder.decodeObjectForKey("timestamp") as? NSDate
        self.workoutArray = aDecoder.decodeObjectForKey("workoutArray") as! [Run]
        self.totalDistance = aDecoder.decodeDoubleForKey("totalDistance")
        self.totalDonated = aDecoder.decodeDoubleForKey("totalDonated")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(self.distance, forKey: "distance")
        aCoder.encodeDouble(self.duration, forKey: "duration")
        aCoder.encodeDouble(self.calories, forKey: "calories")
        aCoder.encodeObject(self.timestamp, forKey: "timestamp")
        aCoder.encodeObject(workoutArray, forKey: "workoutArray")
        aCoder.encodeDouble(self.totalDistance, forKey: "totalDistance")
        aCoder.encodeDouble(self.totalDonated, forKey: "totalDonated")
    }
    
    func add(run: Run) {
        self.workoutArray.append(run)
    }
    
    func save() {
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "workoutList")
    }
    
    class func loadSaved() -> Run? {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("workoutList") as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Run
        }
        return nil
    }
    
    /*func saveWorkout(run: Run) {
        let workoutList = Run.loadSaved()
        workoutList?.add(run)
        workoutList?.save()
    }*/
    
    func saveWorkout(run: Run) {
        self.workoutArray.append(run)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(run, toFile: Run.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save meals...")
        }
    }
    
    func loadWorkout() -> Run? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Run.ArchiveURL.path!) as? Run
    }
}
