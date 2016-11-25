//
//  L3sMatchDetailTableViewCell.swift
//  Live3s
//
//  Created by phuc on 12/10/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import UIKit

class L3sMatchDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var timeEventLabel: UILabel!
    @IBOutlet weak var playerNameEventLabel: UILabel!
    @IBOutlet weak var homePlayerNameEvent: UILabel!
    
    @IBOutlet weak var iconEventImage: UIImageView!
    @IBOutlet weak var iconEventHome: UIImageView!
    
    var infor: MatchDetailEvent! {
        didSet {
            timeEventLabel.text = infor.minute
            playerNameEventLabel.text = (infor.away_event == "xxx") ? "" : infor.away_event
            homePlayerNameEvent.text = (infor.home_event == "xxx") ? "" : infor.home_event
            let isHomeEvent = (infor.home_event == "") ? false : true
            let imageView = isHomeEvent ? iconEventHome : iconEventImage
            switch infor.event_type {
            case "goal":
                imageView.image = UIImage(named: "ball_black.png")
            case "yellow_card":
                imageView.image = UIImage(named: "card_yellow.png")
            case "two_yellows":
                imageView.image = UIImage(named: "card_nested.png")
            case "red_card":
                imageView.image = UIImage(named: "card_red.png")
            case "own_goal":
                imageView.image = UIImage(named: "ball_red.png")
            case "penalty":
                imageView.image = UIImage(named: "ball_green.png")
            case "penalty_off":
                imageView.image = UIImage(named: "L.png")
            case "substitution_in":
                imageView.image = UIImage(named: "sub_in.png")
            case "substitution_out":
                imageView.image = UIImage(named: "sub_out.png")
            default: break
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
    
    override func prepareForReuse() {
        timeEventLabel.text = nil
        playerNameEventLabel.text = nil
        homePlayerNameEvent.text = nil
        iconEventImage.image = nil
        iconEventHome.image = nil
    }
}
