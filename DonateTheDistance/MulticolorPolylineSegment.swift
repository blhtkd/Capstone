//
//  MulticolorPolylineSegment.swift
//  DonateTheDistance
//
//  Created by MU IT Program on 4/6/16.
//  Copyright © 2016 Brooke Haile-Mariam. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MulticolorPolylineSegment: MKPolyline {
    var color: UIColor?
    
    // Returns the array of speed values for each sequential pair of locations, along with the minimum and maximum speeds wrapped in a tuple to return all values
    private class func allSpeeds(forLocations locations: [CLLocation]) ->
        (speeds: [Double], minSpeed: Double, maxSpeed: Double) {
            // Make array of all speeds. Find slowest and fastest
            var speeds = [Double]()
            var minSpeed = DBL_MAX
            var maxSpeed = 0.0
            
            // Loop through all locations
            for i in 1..<locations.count {
                let l1 = locations[i-1]
                let l2 = locations[i]
                
                // Convert from type Location to CLLocation
                //let cl1 = CLLocation(latitude: l1.valueForKey("latitude") as! Double, longitude: l1.valueForKey("longitude") as! Double)
                //let cl2 = CLLocation(latitude: l2.valueForKey("latitude") as! Double, longitude: l2.valueForKey("longitude") as! Double)
                
                // Calculate distance
                let distance = l2.distanceFromLocation(l1)
                let time = (l2.valueForKey("timestamp") as! NSDate).timeIntervalSinceDate(l1.valueForKey("timestamp") as! NSDate)
                let speed = distance/time
                
                // Each location after the first is compared to the one before it
                minSpeed = min(minSpeed, speed)
                maxSpeed = max(maxSpeed, speed)
                
                // Creates a complete collection of all the changes in speed throughout the run
                speeds.append(speed)
            }
            
            return (speeds, minSpeed, maxSpeed)
    }
    
    class func colorSegments(forLocations locations: [CLLocation]) -> [MulticolorPolylineSegment] {
        var colorSegments = [MulticolorPolylineSegment]()
        
        // RGB for Red (slow)
        let red = (r: 1.0, g: 20.0 / 255.0, b: 44.0 / 255.0)
        
        // RGB for Yellow (medium)
        let yellow = (r: 1.0, g: 215.0 / 255.0, b: 0.0)
        
        // RGB for Green (fast)
        let green = (r: 0.0, g: 146.0 / 255.0, b: 78.0 / 255.0)
        
        let (speeds, minSpeed, maxSpeed) = allSpeeds(forLocations: locations)
        
        // We can calculate the mean using the slowest and fastest speeds
        let meanSpeed = (minSpeed + maxSpeed)/2
        
        // This loop determines the value of each pre-calculated speed, relative to the full range of speeds
        for i in 1..<locations.count {
            let l1 = locations[i-1]
            let l2 = locations[i]
            
            var coords = [CLLocationCoordinate2D]()
            
            coords.append(CLLocationCoordinate2D(latitude: l1.coordinate.latitude, longitude: l1.coordinate.longitude))
            coords.append(CLLocationCoordinate2D(latitude: l2.coordinate.latitude, longitude: l2.coordinate.longitude))
            
            let speed = speeds[i-1]
            var color = UIColor.blackColor()
            
            // This ratio then determines the UIColor to apply to the segment
            if speed < minSpeed {
                // Between Red & Yellow
                let ratio = (speed - minSpeed) / (meanSpeed - minSpeed)
                let r = CGFloat(red.r + ratio * (yellow.r - red.r))
                let g = CGFloat(red.g + ratio * (yellow.g - red.g))
                let b = CGFloat(red.r + ratio * (yellow.r - red.r))
                color = UIColor(red: r, green: g, blue: b, alpha: 1)
            }
            else {
                // Between Yellow & Green
                let ratio = (speed - meanSpeed) / (maxSpeed - meanSpeed)
                let r = CGFloat(yellow.r + ratio * (green.r - yellow.r))
                let g = CGFloat(yellow.g + ratio * (green.g - yellow.g))
                let b = CGFloat(yellow.b + ratio * (green.b - yellow.b))
                color = UIColor(red: r, green: g, blue: b, alpha: 1)
            }
            
            // Construct a new MulticolorPolylineSegment with the two coordinates and the blended color
            let segment = MulticolorPolylineSegment(coordinates: &coords, count: coords.count)
            segment.color = color
            colorSegments.append(segment)
        }
        
        return colorSegments
    }
    
}

