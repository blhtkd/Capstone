//
//  DonationData.swift
//  DonateTheDistance
//
//  Created by MU IT Program on 4/23/16.
//  Copyright © 2016 Brooke Haile-Mariam. All rights reserved.
//

import UIKit

class DonationData: NSObject {
    // MARK: Properties
    var JohnsonAndJohnson = 0.0
    var Google = 0.0
    var Chobani = 0.0
    var Target = 0.0
    
    var HabitatForHumanity = 0.0
    var HumaneSociety = 0.0
    var StandUpToCancer = 0.0
    var CharityWater = 0.0
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("data")
    
    // MARK: NSCoding
    required convenience init?(coder decoder: NSCoder) {
        self.init()
        
        self.JohnsonAndJohnson = decoder.decodeDoubleForKey("JohnsonAndJohnson")
        self.Google = decoder.decodeDoubleForKey("Google")
        self.Chobani = decoder.decodeDoubleForKey("Chobani")
        self.Target = decoder.decodeDoubleForKey("Target")
        
        self.HabitatForHumanity = decoder.decodeDoubleForKey("HabitatForHumanity")
        self.HumaneSociety = decoder.decodeDoubleForKey("HumaneSociety")
        self.StandUpToCancer = decoder.decodeDoubleForKey("StandUpToCancer")
        self.CharityWater = decoder.decodeDoubleForKey("CharityWater")
    }
    
    func encodeWithCoder(coder: NSCoder) {
        
        coder.encodeDouble(self.JohnsonAndJohnson, forKey: "JohnsonAndJohnson")
        coder.encodeDouble(self.Google, forKey: "Google")
        coder.encodeDouble(self.Chobani, forKey: "Chobani")
        coder.encodeDouble(self.Target, forKey: "Target")
        
        coder.encodeDouble(self.HabitatForHumanity, forKey: "HabitatForHumanity")
        coder.encodeDouble(self.HumaneSociety, forKey: "HumaneSociety")
        coder.encodeDouble(self.StandUpToCancer, forKey: "StandUpToCancer")
        coder.encodeDouble(self.CharityWater, forKey: "CharityWater")
    }
    
}
