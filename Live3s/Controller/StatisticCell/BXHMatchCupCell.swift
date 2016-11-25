//
//  BXHMatchCupCell.swift
//  Live3s
//
//  Created by codelover2 on 20/12/2015.
//  Copyright © Năm 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import UIKit
class BXHMatchCupCell: UITableViewCell {
    
    
    @IBOutlet weak var lblAwayGoal: UILabel!
    @IBOutlet weak var lblHomeGoal: UILabel!
    @IBOutlet weak var lblAwayClub: UILabel!
    @IBOutlet weak var lblHomeClub: UILabel!
    @IBOutlet weak var lblDatetime: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}