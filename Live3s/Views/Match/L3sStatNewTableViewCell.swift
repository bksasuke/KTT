//
//  L3sStatNewTableViewCell.swift
//  Live3s
//
//  Created by phuc on 1/18/16.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import UIKit

class L3sStatNewTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var awayStat: UILabel!
    @IBOutlet weak var homeStat: UILabel!
    @IBOutlet weak var homecheck: UIImageView!
    @IBOutlet weak var awayCheck: UIImageView!
    
    var stat: Stat! {
        didSet {
            titleLabel.text = stat.statsName
            if stat.awayValue.lowercaseString == "YES".lowercaseString {
                homecheck.hidden = true
                awayCheck.hidden = false
            } else if stat.homeValue.lowercaseString == "YES".lowercaseString {
                homecheck.hidden = false
                awayCheck.hidden = true
            } else {
                homeStat.text = stat.homeValue
                awayStat.text = stat.awayValue
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.backgroundColor = HEADER_BACKGROUND_COLOR
        titleLabel.layer.cornerRadius = 5
        titleLabel.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        homecheck.hidden = true
        awayCheck.hidden = true
        homeStat.text = ""
        awayStat.text = ""
    }
}
