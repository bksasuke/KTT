//
//  MatchCell.swift
//  Live3s
//
//  Created by codelover2 on 19/02/2016.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import Foundation
import UIKit
class MatchCell: UITableViewCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var homename: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var awayname: UILabel!
    @IBOutlet weak var imageFavorite: UIImageView!
    @IBOutlet weak var btnFavorite: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTime.layer.cornerRadius = 5
        self.lblTime.clipsToBounds = true
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBOutlet weak var actionFavorite: UIButton!
}
