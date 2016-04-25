//
//  CharityTableViewCell.swift
//  DonateTheDistance
//
//  Created by Brooke Haile-Mariam on 12/21/15.
//  Copyright © 2015 Brooke Haile-Mariam. All rights reserved.
//

import UIKit

class CharityTableViewCell: UITableViewCell {

    //Cell Properties
    @IBOutlet weak var charityNameLabel: UILabel!
    @IBOutlet weak var charityImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
