//
//  L3sTopScoreCell.swift
//  Live3s
//
//  Created by phuc on 3/6/16.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import UIKit

class L3sTopScoreCell: UITableViewCell {

    //MARK: IBOutLet
    @IBOutlet weak var lblPlayerName: UILabel!
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var lblGoal: UILabel!
    @IBOutlet weak var lblPen: UILabel!
    @IBOutlet weak var lblFirstGoal: UILabel!
    
    var entity: TopScoreStandingModule? {
        didSet {
            lblPlayerName.text = entity!.name_player
            lblTeamName.text = entity!.team
            lblGoal.text = entity!.number_goals
            lblPen.text = entity!.number_penalties
            lblFirstGoal.text = entity?.number_first_goals
        }
    }
    
    //MARK: FUNCTION
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        lblPlayerName.text = ""
        lblTeamName.text = ""
        lblGoal.text = ""
        lblPen.text = ""
        lblFirstGoal.text = ""
    }
}
