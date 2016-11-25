//
//  L3sTpsTableViewCell.swift
//  Live3s
//
//  Created by phuc on 1/24/16.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import UIKit

class L3sTpsTableViewCell: UITableViewCell {

    @IBOutlet weak var seasonTitleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var homeClubnameTitle: UILabel!
    @IBOutlet weak var awayClubNameTitle: UILabel!
    
    private var star: Int = 0 {
        didSet {
            for aindex in 1001...1005 {
                let imgView = viewWithTag(aindex) as! UIImageView
                if (aindex % 1000) <= star {
                    imgView.image = UIImage(named: "Favorite.png")
                } else {
                    imgView.image = UIImage(named: "Favorite_black.png")
                }
            }
        }
    }
    
    var tip: TipsModule? {
        didSet {
            if let tip = tip {
                let seasons = Season.findByID(String(tip.season_id))
                seasonTitleLabel.text = seasons?.name
                let timeString = DateManager.shareManager.dateToString(tip.time_start, format: "dd/MM HH:mm")
                timeLabel.text = timeString
                homeClubnameTitle.text = tip.home_club_name
                awayClubNameTitle.text = tip.away_club_name
                star = tip.count_star
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
