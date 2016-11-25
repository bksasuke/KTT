//
//  L3sStaticTableViewCell.swift
//  Live3s
//
//  Created by phuc on 1/5/16.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import UIKit

class L3sStaticTableViewCell: UITableViewCell {

    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var homeClubNameLabel: UILabel!
    @IBOutlet weak var awayclubNamelabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultIcon: UIImageView!
    
    var infor: StaticMatch? {
        didSet {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM"
            let date = NSDate(timeIntervalSince1970: infor!.timeStart)
            let dateString = dateFormatter.stringFromDate(date)
            timeLabel.text = dateString
            homeClubNameLabel.text = infor?.homeName
            awayclubNamelabel.text = infor?.awayName
            resultLabel.text = "\(infor!.homeGoal)-\(infor!.awayGoal)"
            if infor!.awayGoal == infor!.homeGoal {
                resultIcon.image = UIImage(named: "D.png")
            } else if infor!.awayGoal < infor!.homeGoal {
                resultIcon.image = UIImage(named: "w.png")
            } else {
                resultIcon.image = UIImage(named: "L.png")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        resultLabel.layer.cornerRadius = 5;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
