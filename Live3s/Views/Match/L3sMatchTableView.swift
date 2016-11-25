//
//  L3sMatchTableView.swift
//  Live3s
//
//  Created by phuc on 12/10/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import UIKit

class L3sMatchTableView: UITableView {

    var adatasource: [MatchDetailEvent]! {
        didSet {
            reloadData()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.registerNib(UINib(nibName: "L3sMatchDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "L3sMatchTableViewCell")
        self.registerNib(UINib(nibName: "L3sStatNewTableViewCell", bundle: nil), forCellReuseIdentifier: "L3sStatTableViewCell")
        separatorStyle = .None
        backgroundColor = HEADER_BACKGROUND_COLOR
        allowsSelection = false
    }
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.registerNib(UINib(nibName: "L3sMatchDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "L3sMatchTableViewCell")
        self.registerNib(UINib(nibName: "L3sStatNewTableViewCell", bundle: nil), forCellReuseIdentifier: "L3sStatTableViewCell")
        separatorStyle = .None
        backgroundColor = HEADER_BACKGROUND_COLOR
        allowsSelection = false
    }
}

