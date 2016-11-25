//
//  L3sMatchStatsView.swift
//  Live3s
//
//  Created by phuc on 12/12/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import UIKit

class L3sMatchStatsView: UIView {

    var dataSource: [Stat]? {
        didSet {
            tableView.reloadData()
        }
    }
    private var tableView: UITableView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }
    
    private func createView() {
        tableView = UITableView(frame: bounds, style: .Plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = HEADER_BACKGROUND_COLOR
        tableView.allowsSelection = false
        tableView.registerNib(UINib(nibName: "L3sStatTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        addSubview(tableView)
    }
}

extension L3sMatchStatsView: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! L3sStatTableViewCell
        let stat = dataSource![indexPath.row]
        cell.stat = stat
        return cell
    }
    
}

extension L3sMatchStatsView: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewFrame = CGRectMake(0, 0, tableView.frame.size.width , 20)
        let view = UILabel(frame: viewFrame)
        view.backgroundColor = UIColor.whiteColor()
        return view
    }
}

extension UITableView {
    func defaultViewForHeader(title: String) -> UIView {
        let viewFrame = CGRectMake(0, 0, frame.width, defaultHeightForHeader())
        let view = UILabel(frame: viewFrame)
        view.textAlignment = .Center
        view.backgroundColor = UIColor(rgba: "#595858")
        view.textColor = UIColor.whiteColor()
        view.font = UIFont.boldSystemFontOfSize(15)
        view.text = AL0604.localization(title)
        return view
    }
      func defaultHeightForHeader() -> CGFloat {
        return 40
    }
}