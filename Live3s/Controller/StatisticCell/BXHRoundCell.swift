//
//  BXHRoundCell.swift
//  Live3s
//
//  Created by codelover2 on 18/12/2015.
//  Copyright © Năm 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import UIKit
class BXHRoundCell: UITableViewCell {
    
    @IBOutlet weak var lblDiem: UILabel!
    @IBOutlet weak var lblHieuSo: UILabel!
    @IBOutlet weak var lblThua: UILabel!
    @IBOutlet weak var lblHoa: UILabel!
    @IBOutlet weak var lblThang: UILabel!
    @IBOutlet weak var lblSotran: UILabel!
    @IBOutlet weak var lblIndex: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}