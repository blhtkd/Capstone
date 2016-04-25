//
//  CharitySelectionViewController.swift
//  DonateTheDistance
//
//  Created by Brooke Haile-Mariam on 12/19/15.
//  Copyright © 2015 Brooke Haile-Mariam. All rights reserved.
//

import UIKit

class CharitySelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var registrationComplete : Bool = false
    
    let charityNames: [String] = ["The Humane Society", "Charity: Water", "Stand Up 2 Cancer", "Habitat for Humanity", "Feeding America", "World Wildlife Fund", "St. Jude", "Wounded Warrior Project"]
    let charityIconNames: [String] = ["TheHumaneSociety.jpg", "CharityWater.png", "StandUpToCancer.png", "HabitatForHumanity.png", "FeedingAmerica.png", "WWF.png", "St.Jude.png", "WWP.png"]
    let charityDescriptions: [String] = [
        "Our most important goal is to prevent animals from getting into situations of distress in the first place. We confront the largest national and international problems facing animals, which local shelters don't have the reach or the resources to take on. Founded in 1954, The Humane Society of the United States celebrates animals and confronts cruelty—to all animals, not just dogs and cats. We take on the biggest transformational fights to stop large-scale cruelties, such as animal fighting, puppy mills, factory farming, and the wildlife trade. We will pass anti-cruelty laws in every nation, end extreme confinement of farm animals in cages, stop cosmetic testing on animals, halt cruelty to wildlife, and transform the landscape for pets in poverty. We and our affiliates also care for more than 100,000 animals each year, through our rescue teams, sanctuaries and wildlife centers, free veterinary care for low-income pet owners, and other life-saving programs. The HSUS is approved by the Better Business Bureau's Wise Giving Alliance for all 20 standards for charity accountability, and was named by Worth Magazine as one of the 10 most fiscally responsible charities. For more information, you can read our annual reports and financial statements, as well as check out our latest accomplishments for animals.",
        
        "We’re a nonprofit on a mission to bring clean drinking water to every person on the planet. And with the support of people like you, we’ve funded 19,819 water projects in 24 countries so far. When you fundraise or donate, every dollar goes directly to clean water projects. Private donors fund our operating costs, so 100% of your money can go to the field. We work with local partners to build water projects around the world. And every time we complete one, we prove it using photos and GPS coordinates on Google Maps. When a community gets access to clean water, it can change just about everything. It can improve health, increase access to food, grow local economies, and help kids spend more time in school.",
        
        "Stand Up To Cancer’s (SU2C) mission is to raise funds to accelerate the pace of groundbreaking translational research that can get new therapies to patients quickly and save lives now. SU2C brings together the best and the brightest researchers and mandates collaboration among the cancer community. By galvanizing the entertainment industry, SU2C has set out to generate awareness, educate the public on cancer prevention and help more people diagnosed with cancer become long-term survivors. We now understand the very biology that drives cancer. With knowledge gained from the mapping of the human genome, we can target the genes and pathways that are involved in turning normal cells into cancerous ones. We are on the brink of possessing a toolbox full of new, advanced therapies just waiting to be adapted to benefit patients. Right before us, so close we can almost touch them, are scientific breakthroughs in the prevention, detection, treatment - and even reversal - of this disease. This is where the end of cancer begins: when we unite in one movement, unstoppable.",
        
        "At Habitat for Humanity, we build. We build because we believe that everyone, everywhere, should have a healthy, affordable place to call home. More than building homes, we build communities, we build hope and we build the opportunity for families to help themselves. Your donation will help families break the cycle of poverty and build long-term financial security. With an affordable, stable home, families have more to spend on food, medicine, child care, education and other essentials. Your support can help us do more in all the many ways that Habitat builds. Thanks to you, Habitat is transforming the lives of more than 5 million people around the world!",
    
        "Feeding America is a nationwide network of food banks and the nation's leading domestic hunger-relief charity. Together, we provide food to more than 46 million people through 60,000 food pantries and meal programs. With your support, we can feed the hungry and engage our country in the fight to end hunger. Make your hunger donation below and give hope to the 1 in 7 people facing hunger in America. The Feeding America network of food banks is leading the fight against hunger in communities nationwide. Our mission is to feed America’s hungry through a nationwide network of member food banks and engage our country in the fight to end hunger. Feeding America employs almost 200 people in our Chicago national office, our Washington, D.C. office and across the country to serve the needs of the people we help and our network of member food banks.",
    
        "For 50 years, WWF has been protecting the future of nature. The world’s leading conservation organization, WWF works in 100 countries and is supported by 1.2 million members in the United States and close to 5 million globally. WWF's unique way of working combines global reach with a foundation in science, involves action at every level from local to global, and ensures the delivery of innovative solutions that meet the needs of both people and nature. WWF-US is part of the WWF global network which has worked for more than 50 years to protect the future of nature. In 2016, WWF embraced a bold new strategy and transformation designed to make the organization stronger and even more effective in tackling the challenges ahead. In this video, Marco Lambertini, Director General, WWF International, talks about WWF’s new way of working and commitment to conservation results.",
    
        "St. Jude is leading the way the world understands, treats and defeats childhood cancer and other life-threatening diseases. The mission of St. Jude Children’s Research Hospital is to advance cures, and means of prevention, for pediatric catastrophic diseases through research and treatment. Consistent with the vision of our founder Danny Thomas, no child is denied treatment based on race, religion or a family's ability to pay. Families never receive a bill from St. Jude for treatment, travel, housing or food — because all a family should worry about is helping their child live. St. Jude has treated children from all 50 states and from around the world. Treatments invented at St. Jude have helped push the overall childhood cancer survival rate from 20% to more than 80% since it opened more than 50 years ago.",
    
        "Our mission is to honor and empower Wounded Warriors. Our vision is to foster the most successful, well-adjusted generation of wounded service members in our nation's history. We want to raise awareness and enlist the public's aid for the needs of injured service members, to help injured service members aid and assist each other, and to provide unique, direct programs and services to meet the needs of injured service members. Everyone’s recovery process is different. Depending where you are in your own rehabilitative and transitional process, we hope you find a program that fits you and/or your family’s needs. As we continue to discover the ever-evolving needs of you and your fellow Wounded Warriors, WWP programs are also ever-evolving, so check back often to see what’s new at Wounded Warrior Project® (WWP)."]
    
    var charities : [Charity] = []
    
    @IBOutlet weak var tableView: UITableView!
    var activitySelection = ActivitySelectionViewController()
    var charitySelected = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        initCharities()
    }
    
    func initCharities() {
        for i in 0...(charityNames.count - 1) {
            charities.append(Charity(name: charityNames[i], description: charityDescriptions[i], iconName: charityIconNames[i]))
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charityNames.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.contentView.backgroundColor = UIColor(netHex: 0x636466)
        
        /*let whiteRoundedView : UIView = UIView(frame: CGRectMake(0, 10, self.view.frame.size.width, 120))
        //whiteRoundedView.backgroundColor = UIColor(netHex: 0x636466)
        //whiteRoundedView.layer.backgroundColor = UIColor(netHex: 0x636466)
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSizeMake(-1, 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        whiteRoundedView.backgroundColor = UIColor(netHex: 0x636466)
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)*/
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "CharityTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CharityTableViewCell
        cell.charityNameLabel.text = charityNames[indexPath.row]
        cell.charityImageView.image = UIImage(named: charityIconNames[indexPath.row])
        cell.contentView.backgroundColor = UIColor(netHex: 0x636466)
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        charitySelected = charityNames[indexPath.row]
        //performSegueWithIdentifier("toCharityDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let selectedIndex = self.tableView.indexPathForCell(sender as! UITableViewCell)
        
        let destinationViewController = segue.destinationViewController as! ActivitySelectionViewController
        destinationViewController.charity = charities[(selectedIndex?.row)!]
    }
}
