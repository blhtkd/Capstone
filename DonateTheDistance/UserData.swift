//
//  UserData.swift
//  DonateTheDistance
//
//  Created by MU IT Program on 2/3/16.
//  Copyright © 2016 Brooke Haile-Mariam. All rights reserved.
//

import UIKit

class UserData: NSObject {
    // MARK: Properties
    var firstName = ""
    var lastName = ""
    var height = 0
    var weight = 0
    
    var registrationDate = NSDate()
    var registrationComplete = false
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("user")
    
    // MARK: Initialization
    init(firstName: String, lastName: String, height: Int, weight: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.height = height
        self.weight = weight
    }
    
    override init(){}
    
    // MARK: NSCoding
    required convenience init?(coder decoder: NSCoder) {
        self.init()
        
        self.firstName = (decoder.decodeObjectForKey("firstName") as? String)!
        self.lastName = (decoder.decodeObjectForKey("lastName") as? String)!
        
        self.height = decoder.decodeIntegerForKey("height")
        self.weight = decoder.decodeIntegerForKey("weight")
        
        self.registrationDate = (decoder.decodeObjectForKey("registrationDate") as? NSDate)!
        self.registrationComplete = (decoder.decodeBoolForKey("registrationComplete"))
    }

    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.firstName, forKey: "firstName")
        coder.encodeObject(self.lastName, forKey: "lastName")
        
        coder.encodeInteger(self.height, forKey: "height")
        coder.encodeInteger(self.weight, forKey: "weight")
        
        coder.encodeObject(self.registrationDate, forKey: "registrationDate")
        coder.encodeBool(self.registrationComplete, forKey: "registrationComplete")
    }
}
