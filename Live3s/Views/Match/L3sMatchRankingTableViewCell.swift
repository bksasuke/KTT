//
//  L3sMatchRankingTableViewCell.swift
//  Live3s
//
//  Created by phuc on 12/15/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import UIKit

class L3sMatchRankingTableViewCell: UITableViewCell {

    // outlet
    @IBOutlet weak var clubName: UILabel!
    @IBOutlet weak var totalMatch: UILabel!
    @IBOutlet weak var totalWin: UILabel!
    @IBOutlet weak var totalDraw: UILabel!
    @IBOutlet weak var totalLose: UILabel!
    @IBOutlet weak var totalGoal: UILabel!
    @IBOutlet weak var totalPoint: UILabel!
    var ranking: MatchRanking! {
        didSet {
            totalMatch.text = "\(ranking.totalMatch)"
            totalWin.text = "\(ranking.totalWin)"
            totalDraw.text = "\(ranking.totalDraw)"
            totalLose.text = "\(ranking.totalLose)"
            totalGoal.text = "\(ranking.totalGoal)"
            totalPoint.text = "\(ranking.totalPoint)"
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
