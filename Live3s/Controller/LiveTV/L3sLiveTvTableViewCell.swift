//
//  L3sLiveTvTableViewCell.swift
//  Live3s
//
//  Created by phuc on 2/26/16.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import UIKit

class L3sLiveTvTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbHomeClugName: UILabel!
    @IBOutlet weak var lbAwayClubName: UILabel!
    
    var match: MatchTVOBJ? {
        didSet {
            for matchUpdate:MatchUpdateOBJ in L3sAppDelegate.arrayUpdate {
                if match?.id == matchUpdate.match_id {
                    match!.status = matchUpdate.status
                    match!.home_goal = matchUpdate.home_goal
                    match!.away_goal = matchUpdate.away_goal
                    match!.home_goalH1 = matchUpdate.home_goalH1
                    match!.away_goalH1 = matchUpdate.away_goalH1
                    
                }
            }
            let currentDate = NSDate()
            let currentDateInterval: NSTimeInterval = currentDate.timeIntervalSinceNow
            let doubleCurrent = Double(NSNumber(double: currentDateInterval))
            let matchTime = Double(match!.time_start)
            if matchTime > doubleCurrent {
                let time = DateManager.shareManager.dateToString(match!.time_start, format: "HH:mm")
                let date = DateManager.shareManager.dateToString(match!.time_start, format: "dd/MM")
                lbTime.text = String(format: "%@\n%@", date, time)
            } else {
                lbTime.text = match!.status
            }
            lbHomeClugName.text = match!.home_club_name
            lbAwayClubName.text = match!.away_club_name
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lbTime.layer.cornerRadius = 5
        lbTime.clipsToBounds = true
        accessoryType = .DisclosureIndicator
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
