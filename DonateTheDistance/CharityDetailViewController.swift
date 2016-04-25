//
//  CharityDetailViewController.swift
//  DonateTheDistance
//
//  Created by MU IT Program on 1/29/16.
//  Copyright © 2016 Brooke Haile-Mariam. All rights reserved.
//

import UIKit

class CharityDetailViewController: UIViewController {

    var charity:Charity = Charity(name: "", description: "", iconName: "");
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var charityLabel: UILabel!
    @IBOutlet weak var charityDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(netHex: 0x636466)
        charityLabel.text = charity.name
        charityDescription.text = charity.description
        imageView.image = UIImage(named: charity.iconName)
    }

}
