//
//  WalkResults.swift
//  DonateTheDistance
//
//  Created by Brendon Sexe on 4/25/16.
//  Copyright © 2016 Brooke Haile-Mariam. All rights reserved.
//

import UIKit

class WalkResults: UIViewController {

    @IBOutlet weak var steps: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var money: UILabel!
    var run: Run!
    var moneyString: String = ""
    var distanceString: String = ""
    var caloriesString: String = ""
    var stepString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepString = String(format: "%.2f", run.duration)
        steps.text = stepString
        caloriesString = String(format: "%.2f", run.calories)
        calories.text = caloriesString
        distanceString = String(format: "%.2f", run.distance)
        distance.text = distanceString
        moneyString = String(format: "%.2f", run.totalDonated)
        money.text = moneyString
    }
    
}
