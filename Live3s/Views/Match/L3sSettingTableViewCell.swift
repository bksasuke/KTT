//
//  L3sSettingTableViewCell.swift
//  Live3s
//
//  Created by phuc on 1/18/16.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import UIKit

protocol L3sSettingTableViewCellDelegate: NSObjectProtocol{
    func actionChangeRegister(cell: L3sSettingTableViewCell)
}

class L3sSettingTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    
    var delegate: L3sSettingTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func changeRegister(sender: AnyObject) {
        self.delegate?.actionChangeRegister(self)
    }
}
