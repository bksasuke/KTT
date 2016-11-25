//
//  L3sSettingView.swift
//  Live3s
//
//  Created by phuc on 1/18/16.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import RealmSwift
import UIKit

enum IndexRegister: Int {
    case Kickoff = 0, Goal, RedCard, Halftime, FullTime
}

enum TypeRegister: Int {
    case Kickoff = 1, Goal, Halftime, RedCard, FullTime
}

class L3sSettingView: UIView {
    
    var tableView: UITableView!
    var leagueID:String?
    var matchID:String? {
        didSet {
            if let matchID = matchID {
                matchPush = MatchPush.findByID(matchID)
                tableView.reloadData()
            }else{
                matchPush = MatchPush.findByID("9999")
                tableView.reloadData()
            }
        }
    }
    var matchPush: MatchPush?
    
    var dataSource = [
        "Kick Off",
        "Goal",
        "Red Card",
        "Half Time",
        "Full Time",]
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
        if let matchID = matchID {
            matchPush = MatchPush.findByID(matchID)
            tableView.reloadData()
        }else{
            matchPush = MatchPush.findByID("9999")
            tableView.reloadData()
        }
      
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createView()
        if let matchID = matchID {
            matchPush = MatchPush.findByID(matchID)
            tableView.reloadData()
        }else{
            matchPush = MatchPush.findByID("9999")
            tableView.reloadData()
        }

        
    }
    
    private func createView() {
        backgroundColor = UIColor.whiteColor()
        tableView = UITableView(frame: bounds, style: .Plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.allowsSelection = false
        tableView.registerNib(UINib(nibName: "L3sSettingTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        addSubview(tableView)
    }
    
    func registerPush(matchID:String, pushType:String, status:String) {
        NetworkService.registerPush(status, matchID: matchID, pushType: pushType) { (result, pushType, status, error) in
            if result == "success"{
                    switch Int(pushType)! {
                    case TypeRegister.Kickoff.rawValue:
                        self.matchPush?.kickoff = Int(status)
                        MatchPush.saveMatchPush(self.matchPush!)
                        break
                    case TypeRegister.Goal.rawValue:
                        self.matchPush?.goal = Int(status)
                        MatchPush.saveMatchPush(self.matchPush!)
                        break
                    case TypeRegister.RedCard.rawValue:
                        self.matchPush?.redcard = Int(status)
                        MatchPush.saveMatchPush(self.matchPush!)
                        break
                    case TypeRegister.Halftime.rawValue:
                        self.matchPush?.halftime = Int(status)
                        MatchPush.saveMatchPush(self.matchPush!)
                        break
                    case TypeRegister.FullTime.rawValue:
                        self.matchPush?.fulltime = Int(status)
                        MatchPush.saveMatchPush(self.matchPush!)
                        break
                    default:
                        break
                    }
            }else{
                
            }
        }
    }
    
}

extension L3sSettingView: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! L3sSettingTableViewCell
        cell.delegate = self
        if indexPath.row == 0 {
            cell.titleLabel.font = UIFont.systemFontOfSize(17)
        } else {
            cell.titleLabel.font = UIFont.systemFontOfSize(14)
        }
         cell.switchControl.setOn(false, animated: false)
        if let matchPush = self.matchPush{
            switch indexPath.row {
            case IndexRegister.Kickoff.rawValue:
                if matchPush.kickoff == 2{
                    cell.switchControl.setOn(false, animated: false)
                }else{
                    cell.switchControl.setOn(true, animated: false)
                }
                break
            case IndexRegister.Goal.rawValue:
                if matchPush.goal == 2{
                    cell.switchControl.setOn(false, animated: false)
                }else{
                    cell.switchControl.setOn(true, animated: false)
                }
                break
            case IndexRegister.RedCard.rawValue:
                if matchPush.redcard == 2{
                    cell.switchControl.setOn(false, animated: false)
                }else{
                    cell.switchControl.setOn(true, animated: false)
                }
                break
            case IndexRegister.Halftime.rawValue:
                if matchPush.halftime == 2{
                    cell.switchControl.setOn(false, animated: false)
                }else{
                    cell.switchControl.setOn(true, animated: false)
                }
                break
            case IndexRegister.FullTime.rawValue:
                if matchPush.fulltime == 2{
                    cell.switchControl.setOn(false, animated: false)
                }else{
                    cell.switchControl.setOn(true, animated: false)
                }
                break
            default:
                break
            }
            
        }
        guard let defaultRealm = try? Realm(),
            let item = defaultRealm.objectForPrimaryKey(MatchPushList.self, key: AL0604.currentLanguage)?.list,
            let title = item.filter({$0.value == (indexPath.row+1).description}).first else {return cell}
        cell.titleLabel.text = title.name
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        } else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}

extension L3sSettingView: L3sSettingTableViewCellDelegate{
    func actionChangeRegister(cell: L3sSettingTableViewCell) {
        let indexPath = tableView.indexPathForCell(cell)
        if let matchPush = self.matchPush{
            switch indexPath!.row {
            case IndexRegister.Kickoff.rawValue:
                if matchPush.kickoff == 1{
                    registerPush(matchID!, pushType: "1", status: "2")
                }else{
                    registerPush(matchID!, pushType: "1", status: "1")
                }
                break
            case IndexRegister.Goal.rawValue:
                if matchPush.goal == 1{
                    registerPush(matchID!, pushType: "2", status: "2")
                }else{
                    registerPush(matchID!, pushType: "2", status: "1")
                }
                break
            case IndexRegister.RedCard.rawValue:
                if matchPush.redcard == 1{
                    registerPush(matchID!, pushType: "4", status: "2")
                }else{
                    registerPush(matchID!, pushType: "4", status: "1")
                }
                break
            case IndexRegister.Halftime.rawValue:
                if matchPush.halftime == 1{
                    registerPush(matchID!, pushType: "3", status: "2")
                }else{
                    registerPush(matchID!, pushType: "3", status: "1")
                }
                break
            case IndexRegister.FullTime.rawValue:
                if matchPush.fulltime == 1{
                    registerPush( matchID!, pushType: "5", status: "2")
                }else{
                    registerPush( matchID!, pushType: "5", status: "1")
                }
                
                break
            default:
                break
            }
            
        }
        
    }
    
}