//
//  RegistrationViewController.swift
//  DonateTheDistance
//
//  Created by MU IT Program on 2/1/16.
//  Copyright © 2016 Brooke Haile-Mariam. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var heightFeetField: UITextField!
    @IBOutlet weak var heightInchesField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var firstName : String = ""
    var lastName : String = ""
    var heightFeet : String = ""
    var heightInches : String = ""
    
    var weight : String = ""
    
    var archiver = UserData()
    var user:UserData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(netHex: 0x636466)
        
        initFields()
    }
    
    //Set the delegate and keyboard types for each input text field
    func initFields() {
        firstNameField.delegate = self
        firstNameField.keyboardType = UIKeyboardType.ASCIICapable
        
        lastNameField.delegate = self
        lastNameField.keyboardType = UIKeyboardType.ASCIICapable
        
        weightField.delegate = self
        weightField.keyboardType = UIKeyboardType.NumberPad
        
        heightFeetField.delegate = self
        heightFeetField.keyboardType = UIKeyboardType.NumberPad
        
        heightInchesField.delegate = self
        heightInchesField.keyboardType = UIKeyboardType.NumberPad
    }

    @IBAction func submit(sender: AnyObject) {
        firstName = firstNameField.text!
        if !(firstName == "") {
            archiver.firstName = firstName
        }
        
        lastName = lastNameField.text!
        if !(lastName == "") {
            archiver.lastName = lastName
        }
        
        heightFeet = heightFeetField.text!
        heightInches = heightInchesField.text!
        var height:Int = 0
        if !(heightFeet == "") {
            if !(heightInches == "") {
                archiver.height = Int(heightInches)! + (12 * Int(heightFeet)!)
                height = Int(heightInches)! + (12 * Int(heightFeet)!)
            }
        }
        
        weight = weightField.text!
        if !(weight == "") {
            archiver.weight = Int(weight)!
        }
        user = UserData(firstName: firstName, lastName: lastName, height: height, weight: Int(weight)!)
        
        user.registrationDate = NSDate()
        saveUser()
        
        archiver.registrationDate = NSDate()
        print(archiver.weight)
        archiver.registrationComplete = true
        performSegueWithIdentifier("toCharityTable", sender: self)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // Ignore any change that doesn't add characters to the text field such as moving the insertion point, return true to allow the change to take place
        if string.characters.count == 0 {
            return true
        }
        
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        let letters = NSCharacterSet.letterCharacterSet()
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        
        switch textField {
        
        // Only allow the user to type the alphabet
        case firstNameField:
            for uni in prospectiveText.unicodeScalars {
                if digits.longCharacterIsMember(uni.value) {
                    return false
                }
            }
            return true
        
        // Only allow the user to type the alphabet
        case lastNameField:
            for uni in prospectiveText.unicodeScalars {
                if digits.longCharacterIsMember(uni.value) {
                    return false
                }
            }
            return true
        
        // Only allow the user to type digits and limit the characters to 3
        case weightField:
            for uni in prospectiveText.unicodeScalars {
                if letters.longCharacterIsMember(uni.value) {
                    return false
                }
            }
            return prospectiveText.characters.count <= 3
            
        // Only allow the user to type digits and limit the characters to 1
        case heightFeetField:
            for uni in prospectiveText.unicodeScalars {
                if letters.longCharacterIsMember(uni.value) {
                    return false
                }
            }
            return prospectiveText.characters.count <= 1
         
        // Only allow the user to type digits and limit the characters to 2
        case heightInchesField:
            for uni in prospectiveText.unicodeScalars {
                if letters.longCharacterIsMember(uni.value) {
                    return false
                }
            }
            return prospectiveText.characters.count <= 2
            
        // Do not put constraints on any other text field in this view that uses this class as its delegate
        default:
            return true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! CharitySelectionViewController
        destinationViewController.registrationComplete = true
    }
    
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }
    
    // Dismiss the keyboard when the user taps the "Return" key while editing a text field.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func saveUser() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(user, toFile: UserData.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save meals...")
        }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
