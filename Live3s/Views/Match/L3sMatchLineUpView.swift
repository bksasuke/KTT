//
//  L3sMatchLineUpView.swift
//  Live3s
//
//  Created by phuc on 12/14/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class L3sMatchLineUpView: UIView {
    
    private var containerView: UIView!

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var homeDataSource = [JSON]() {
        didSet {
            tableView.reloadData()
        }
    }
    var awaySource = [JSON]() {
        didSet {
            tableView.reloadData()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        containerView = commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        containerView = commonInit()        
    }
    // MARK: - private method
    private func commonInit() -> UIView {
        func nibName() -> String {
            return self.dynamicType.description().componentsSeparatedByString(".").last!
        }
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName(), bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.addSubview(view)
        tableView.allowsSelection = false
        segmentedControl.tintColor = HEADER_BACKGROUND_COLOR
        return view
    }
    
    // Mark: - public method
    
    @IBAction func didChangeSelectedSegment(sender: AnyObject) {
        tableView.reloadData()
    }

    func setSegmentedSection(home: String, away: String) {
        segmentedControl.setTitle(home, forSegmentAtIndex: 0)
        segmentedControl.setTitle(away, forSegmentAtIndex: 1)
    }
}

// MARK: - UITableViewDataSource 

extension L3sMatchLineUpView: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var dataSource: [JSON]!
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            dataSource = homeDataSource
        case 1:
            dataSource = awaySource
        default: break
        }
        if dataSource.count < 2 {return 0}
        if section == 0 {
            return dataSource[0].count ?? 0
        } else {
            return dataSource[1].count ?? 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if let acell = tableView.dequeueReusableCellWithIdentifier("Cell") {
            cell = acell
        } else {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        }
        if indexPath.row % 2 == 0{
            cell.backgroundColor = UIColor.whiteColor()
            
        }else{
            cell.backgroundColor = UIColor(rgba: "#f5f5f5")
        }
        var playerName: String!
        var dataSource: [JSON]!
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            dataSource = homeDataSource
        case 1:
            dataSource = awaySource
        default: break
        }
        if indexPath.section == 0 {
            let playerList = dataSource[0]
            playerName = playerList["\(indexPath.row + 1)"].stringValue
        } else {
            let playerList = dataSource[1]
            playerName = playerList["\(indexPath.row + 1)"].stringValue
        }
        cell.textLabel?.text = playerName
        cell.textLabel?.font = UIFont.systemFontOfSize(13)
        return cell
    }
}

extension L3sMatchLineUpView: UITableViewDelegate {
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        } else {
            return AL0604.localization(LanguageKey.formation_sub)
        }
    }
}