//
//  L3sStatTableViewCell.swift
//  Live3s
//
//  Created by phuc on 12/12/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import UIKit

class L3sStatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statName: UILabel!
    // home
    @IBOutlet weak var home_stat: UILabel!
    @IBOutlet weak var homeProgress: UIProgressView!
    @IBOutlet weak var homeCheck: UIImageView!
    // away
    @IBOutlet weak var awayStat: UILabel!
    @IBOutlet weak var awayProgress: UIProgressView!
    @IBOutlet weak var awayChecj: UIImageView!
    
    var stat: Stat! {
        didSet {
            statName.text = stat.statsName
            if stat.awayValue.lowercaseString == "YES".lowercaseString {
                homeCheck.hidden = true
                awayChecj.hidden = false
                homeProgress.progress = 1.0
                awayProgress.progress = 1.0
            } else if stat.homeValue.lowercaseString == "YES".lowercaseString {
                homeCheck.hidden = false
                awayChecj.hidden = true
                homeProgress.progress = 0.0
                awayProgress.progress = 0.0
            } else {
                home_stat.text = stat.homeValue
                awayStat.text = stat.awayValue
                if stat.homePercent != ""{
                    homeProgress.progress = 1 - Float(stat.homePercent)!
                }
                if stat.awayPercent != ""{
                    awayProgress.progress = Float(stat.awayPercent)!
                }
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statName.clipsToBounds = true
        statName.layer.cornerRadius = 5
        homeCheck.hidden = true
        awayChecj.hidden = true
        statName.text = ""
        home_stat.text = ""
        awayStat.text = ""
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        homeCheck.hidden = true
        awayChecj.hidden = true
        statName.text = ""
        home_stat.text = ""
        awayStat.text = ""
        homeProgress.progress = 0.0
        awayProgress.progress = 0.0
    }
}
