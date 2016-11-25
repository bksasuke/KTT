//
//  BXHGroupCupCell.swift
//  Live3s
//
//  Created by codelover2 on 22/12/2015.
//  Copyright © Năm 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import UIKit
class BXHGroupCupCell: UITableViewCell {

    @IBOutlet weak var lblDiem: UILabel!
    @IBOutlet weak var lblHieuSo: UILabel!
    @IBOutlet weak var lblBanbai: UILabel!
    @IBOutlet weak var lblBanthang: UILabel!
    @IBOutlet weak var lblTranthua: UILabel!
    @IBOutlet weak var lblTranhoa: UILabel!
    @IBOutlet weak var lblTranthang: UILabel!
    @IBOutlet weak var lblSotran: UILabel!
    @IBOutlet weak var lblSothutu: UILabel!
    @IBOutlet weak var lblTen: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}