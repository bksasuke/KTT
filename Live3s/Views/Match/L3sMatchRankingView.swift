//
//  L3sMatchRankingView.swift
//  Live3s
//
//  Created by phuc on 12/15/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import UIKit

class L3sMatchRankingView: UIView {

    var dataSource: [MatchRanking]? {
        didSet {
            tableView.reloadData()
        }
    }
    internal var roundType: String?
    internal var isTypeRound = false
    internal var isTypeGroup = false
    internal var isTypeMatch = false
    // Round Type == 1
    internal var leageRankRounds: LeagueRankRound?
    internal var sessionRankRounds: [SessionRankRound]?
    internal var sessionDisplay: SessionRankRound?
    internal var teamRankRounds: [TeamRankRound]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    // Round Type == 2
    internal var leageRankCup: LeagueRankCup?
    internal var roundRankCup: [RoundOBJ]?
    internal var roundCupDiplay: RoundOBJ?
    internal var sessionRankCups: [SessionRankCup]?
    internal var sessionCupDisplay: SessionRankCup?
    internal var teamRankCups: [TeamOBJ]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    internal var groupRankCups: [GroupOBJ]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    internal var matchRankCups: [MatchOBJ]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        containerView = commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        containerView = commonInit()
        tableView.registerNib(UINib(nibName: "BXHRoundCell", bundle: nil), forCellReuseIdentifier: "RoundCell")
        tableView.registerNib(UINib(nibName: "BXHMatchCupCell", bundle: nil), forCellReuseIdentifier: "MatchCupCell")
        tableView.registerNib(UINib(nibName: "BXHGroupCupCell", bundle: nil), forCellReuseIdentifier: "GroupCupCell")
    }
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
        tableView.registerNib(UINib(nibName: "L3sMatchRankingTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.allowsSelection = false
        return view
    }
    

}

extension L3sMatchRankingView: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Giải đấu Quốc Gia
        if self.leageRankRounds != nil{
            return 1
            
            // Giải đấu cúp
        }else{
            
            if self.isTypeMatch{
                return 1
                
            }else if self.isTypeGroup{
                if let countGroup = self.groupRankCups?.count{
                    return countGroup
                }else{
                    return 0
                }
            }else{
                return 1
            }
        }

    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Giải đấu Quốc Gia
        if self.leageRankRounds != nil{
            
            if let countSeason = teamRankRounds?.count{
                return countSeason
            }else {
                return 0
            }
            // Giải đấu cúp
        }else{
            if leageRankCup != nil {
                if self.isTypeMatch{
                    if let countMatch = self.matchRankCups?.count{
                        return countMatch
                    }else{
                        return 0
                    }
                    
                }else if self.isTypeGroup{
                    if let groups = self.groupRankCups{
                        let group = groups[section]
                        return group.teams.count
                        
                    }else{
                        return 0
                    }
                }else{
                    if let countGroup = self.teamRankCups?.count{
                        return countGroup
                    }else{
                        return 0
                    }
                }
            }else{
                return 0
            }
            
        }

    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Giải đấu Quốc Gia
        
        if self.leageRankRounds != nil {
            let cell = tableView.dequeueReusableCellWithIdentifier("RoundCell") as! BXHRoundCell
            let teamOBJ:TeamRankRound = teamRankRounds![indexPath.row]
            cell.lblIndex.text = "\(indexPath.row+1)"
            cell.lblName.text = teamOBJ.football_club_name
            cell.lblSotran.text = teamOBJ.total_match
            cell.lblThang.text = teamOBJ.total_win
            cell.lblHoa.text = teamOBJ.total_draw
            cell.lblThua.text = teamOBJ.total_lose
            cell.lblHieuSo.text = teamOBJ.goal
            cell.lblDiem.text = teamOBJ.point
            cell.selectionStyle = .None
            if indexPath.row % 2 == 0{
                cell.backgroundColor = UIColor.whiteColor()
                
            }else{
                cell.backgroundColor = UIColor(rgba: "#f5f5f5")
            }
            
            return cell
            
            // Giải đấu cúp
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("MatchCupCell") as! BXHMatchCupCell
            if self.isTypeMatch{
                if let array = self.matchRankCups{
                    let matchOBJ:MatchOBJ = array[indexPath.row]
                    for matchUpdate:MatchUpdateOBJ in L3sAppDelegate.arrayUpdate {
                        if matchOBJ.id == matchUpdate.match_id {
                            matchOBJ.status = matchUpdate.status
                            matchOBJ.home_goal = matchUpdate.home_goal
                            matchOBJ.away_goal = matchUpdate.away_goal
                            matchOBJ.home_goalH1 = matchUpdate.home_goalH1
                            matchOBJ.away_goalH1 = matchUpdate.away_goalH1
                            
                        }
                    }
                    cell.lblHomeClub.text = matchOBJ.home_club_name
                    cell.lblAwayClub.text = matchOBJ.away_club_name
                
                    if let intTime:Int = Int(matchOBJ.time_start){
                        if let timeInterval:NSTimeInterval = NSTimeInterval(intTime){
                            let startDate = NSDate(timeIntervalSince1970:timeInterval)
                            let dateFomatter = NSDateFormatter()
                            dateFomatter.dateFormat = "dd/MM - HH:mm"
                            let strTime = dateFomatter.stringFromDate(startDate)
                            cell.lblDatetime.text = strTime
                        }
                        
                        
                    }
                    if matchOBJ.is_finish == "1" {
                        cell.lblStatus.hidden = false
                        cell.lblStatus.text = AL0604.localization(LanguageKey.ft)
                        cell.lblHomeGoal.text = matchOBJ.home_goal
                        cell.lblAwayGoal.text = matchOBJ.away_goal
                    }else{
                        if matchOBJ.is_postponed == "1" {
                            cell.lblStatus.hidden = false
                            cell.lblStatus.text = AL0604.localization(LanguageKey.postpone)
                            cell.lblHomeGoal.text = "?"
                            cell.lblAwayGoal.text = "?"
                        } else {
                            let currentDate = NSDate()
                            let currentDateInterval: NSTimeInterval = currentDate.timeIntervalSinceNow
                            let doubleCurrent = Double(NSNumber(double: currentDateInterval))
                            // Chưa đá
                            let timeStart = Double(matchOBJ.time_start)
                            if timeStart > doubleCurrent {
                                cell.lblStatus.hidden = true
                                cell.lblStatus.text = ""
                                cell.lblHomeGoal.text = "?"
                                cell.lblAwayGoal.text = "?"
                                // Đang đá
                            }else{
                                cell.lblStatus.hidden = false
                                if matchOBJ.status == "" {
                                    cell.lblStatus.text = "Live"
                                }else {
                                    cell.lblStatus.text = matchOBJ.status
                                }
                                cell.lblHomeGoal.text = matchOBJ.home_goal
                                cell.lblAwayGoal.text = matchOBJ.away_goal
                                
                            }
                        }
                    }
                }
                if indexPath.row % 2 == 0{
                    cell.backgroundColor = UIColor.whiteColor()
                    
                }else{
                    cell.backgroundColor = UIColor(rgba: "#f5f5f5")
                }
                
                
            }else if self.isTypeGroup{
                let cell = tableView.dequeueReusableCellWithIdentifier("GroupCupCell") as! BXHGroupCupCell
                if let array = self.groupRankCups{
                    let groupOBJ:GroupOBJ = array[indexPath.section]
                    let arrayTeam  = groupOBJ.teams
                    if  arrayTeam.count > 0{
                        let team:TeamOfGroupOBJ = arrayTeam[indexPath.row]
                        cell.lblSothutu.text = "\(indexPath.row+1)"
                        cell.lblTen.text = team.fc_name
                        cell.lblSotran.text = team.total_match
                        cell.lblTranthang.text = team.total_win
                        cell.lblTranhoa.text = team.total_draw
                        cell.lblTranthua.text = team.total_lose
                        cell.lblBanthang.text = team.total_goal
                        cell.lblBanbai.text = team.total_goal_lose
                        cell.lblDiem.text = team.point
                        cell.lblHieuSo.text = team.subNum
                         cell.backgroundColor = UIColor.whiteColor()
                        
                    }
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("RoundCell") as! BXHRoundCell
                if let array = self.teamRankCups{
                    let teamOBJ:TeamOBJ = array[indexPath.row]
                    cell.lblIndex.text = "\(indexPath.row+1)"
                    cell.lblName.text = teamOBJ.football_club_name
                    cell.lblSotran.text = teamOBJ.total_match
                    cell.lblThang.text = teamOBJ.total_win
                    cell.lblHoa.text = teamOBJ.total_draw
                    cell.lblThua.text = teamOBJ.total_lose
                    cell.lblHieuSo.text = teamOBJ.goal
                    cell.lblDiem.text = teamOBJ.total_point
                    cell.selectionStyle = .None
                    if indexPath.row % 2 == 0{
                        cell.backgroundColor = UIColor.whiteColor()
                        
                    }else{
                        cell.backgroundColor = UIColor(rgba: "#f5f5f5")
                    }
                    

                }
                return cell
                
            }
            return cell
        }

    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let supperView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 60))
        supperView.backgroundColor = UIColor.whiteColor()
        var view:UIView!
        // Xem BXH
            if self.leageRankRounds != nil {
                view = UIView(frame: CGRect(x: 0, y: 20, width: tableView.frame.size.width, height: 40))
                view.backgroundColor = UIColor(rgba: "#595858")
                
                
                let lblMatch = UILabel(frame: CGRect(x: view.frame.size.width - (view.frame.size.width)/1.96 , y: 10, width: 50, height: 20))
                lblMatch.textColor = UIColor.whiteColor()
                lblMatch.font = UIFont.systemFontOfSize(13)
                lblMatch.text = AL0604.localization(LanguageKey.label_total_match)
                
                view.addSubview(lblMatch)
                
                let lblWin = UILabel(frame: CGRect(x: view.frame.size.width - (view.frame.size.width)/2.32, y: 10, width: 50, height: 20))
                lblWin.textColor = UIColor.whiteColor()
                lblWin.font = UIFont.systemFontOfSize(13)
                lblWin.text = AL0604.localization(LanguageKey.label_total_win)
                view.addSubview(lblWin)
                
                let lblDraw = UILabel(frame: CGRect(x: view.frame.size.width - (view.frame.size.width)/2.9, y: 10, width: 50, height: 20))
                lblDraw.textColor = UIColor.whiteColor()
                lblDraw.font = UIFont.systemFontOfSize(13)
                lblDraw.text = AL0604.localization(LanguageKey.label_total_draw)
                view.addSubview(lblDraw)
                
                let lblLose = UILabel(frame: CGRect(x: view.frame.size.width - (view.frame.size.width)/3.9, y: 10, width: 50, height: 20))
                lblLose.textColor = UIColor.whiteColor()
                lblLose.font = UIFont.systemFontOfSize(13)
                lblLose.text = AL0604.localization(LanguageKey.label_total_lose)
                view.addSubview(lblLose)
                
                let lblHS = UILabel(frame: CGRect(x: view.frame.size.width - (view.frame.size.width)/5.5, y: 10, width: 50, height: 20))
                lblHS.textColor = UIColor.whiteColor()
                lblHS.font = UIFont.systemFontOfSize(13)
                lblHS.text = "+/-"
                view.addSubview(lblHS)
                
                let lblPoint = UILabel(frame: CGRect(x: view.frame.size.width - (view.frame.size.width)/12, y: 10, width: 50, height: 20))
                lblPoint.textColor = UIColor.whiteColor()
                lblPoint.font = UIFont.systemFontOfSize(13)
                lblPoint.text = AL0604.localization(LanguageKey.label_total_point)
                view.addSubview(lblPoint)
                
                // Giải đấu cúp
            }else{
                if self.isTypeMatch{
                    view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0))
                    
                }else if self.isTypeGroup{
                    let subView:UIView!
                    if section == 0 {
                        view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 21))
                        view.backgroundColor = UIColor(rgba: "#595858")
                        subView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 21))
                        view.backgroundColor = UIColor(rgba: "#595858")
                        view.addSubview(subView)
                        let labelTop = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
                        labelTop.backgroundColor = UIColor(rgba: "#4b4a4a")
                        subView.addSubview(labelTop)
                    }else{
                        view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 31))
                        view.backgroundColor = UIColor.whiteColor()
                        subView = UIView(frame: CGRect(x: 0, y: 10, width: tableView.frame.size.width, height: 21))
                        subView.backgroundColor = UIColor(rgba: "#595858")
                        view.addSubview(subView)
                        
                    }
                    
                    let image = UIImageView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 21))
                    image.image = UIImage(named: "bg_cellGroup.png")
                    subView.addSubview(image)
                    
                    let lblBang = UILabel(frame: CGRect(x: 8, y: 1, width: 50, height: 20))
                    lblBang.textColor = UIColor.whiteColor()
                    lblBang.font = UIFont.systemFontOfSize(11)
                    let groupOBJ = self.leageRankCup?.arrayGroup[section]
                    lblBang.text = groupOBJ?.name
                    subView.addSubview(lblBang)
                    
                    let lblTen = UILabel(frame: CGRect(x: 27, y: 1, width: 100, height: 20))
                    lblTen.textColor = UIColor.whiteColor()
                    lblTen.font = UIFont.systemFontOfSize(13)
                    lblTen.text = AL0604.localization(LanguageKey.team)
                    subView.addSubview(lblTen)
                    
                    let lblTran = UILabel(frame: CGRect(x: view.frame.size.width - (view.frame.size.width)/2.08 , y: 1, width: 50, height: 20))
                    lblTran.textColor = UIColor.whiteColor()
                    lblTran.font = UIFont.systemFontOfSize(12)
                    lblTran.text = AL0604.localization(LanguageKey.label_total_match)
                    subView.addSubview(lblTran)
                    
                    let lblWin = UILabel(frame: CGRect(x: view.frame.size.width - (view.frame.size.width)/2.4 , y: 1, width: 50, height: 20))
                    lblWin.textColor = UIColor.whiteColor()
                    lblWin.font = UIFont.systemFontOfSize(12)
                    lblWin.text = AL0604.localization(LanguageKey.label_total_win)
                    
                    subView.addSubview(lblWin)
                    
                    let lblDraw = UILabel(frame: CGRect(x: view.frame.size.width - (view.frame.size.width)/2.84 , y: 1, width: 50, height: 20))
                    lblDraw.textColor = UIColor.whiteColor()
                    lblDraw.font = UIFont.systemFontOfSize(12)
                    lblDraw.text = AL0604.localization(LanguageKey.label_total_draw)
                    
                    subView.addSubview(lblDraw)
                    
                    let lbllose = UILabel(frame: CGRect(x: view.frame.size.width - (view.frame.size.width)/3.4, y: 1, width: 50, height: 20))
                    lbllose.textColor = UIColor.whiteColor()
                    lbllose.font = UIFont.systemFontOfSize(12)
                    lbllose.text = AL0604.localization(LanguageKey.label_total_lose)
                    subView.addSubview(lbllose)
                    
                    let lblBT = UILabel(frame: CGRect(x: view.frame.size.width - (view.frame.size.width)/4.3, y: 1, width: 50, height: 20))
                    lblBT.textColor = UIColor.whiteColor()
                    lblBT.font = UIFont.systemFontOfSize(12)
                    lblBT.text = AL0604.localization(LanguageKey.label_goal_for)
                    subView.addSubview(lblBT)
                    
                    let lblBB = UILabel(frame: CGRect(x: view.frame.size.width - (view.frame.size.width)/5.9, y: 1, width: 50, height: 20))
                    lblBB.textColor = UIColor.whiteColor()
                    lblBB.font = UIFont.systemFontOfSize(12)
                    lblBB.text = AL0604.localization(LanguageKey.label_goal_against)
                    subView.addSubview(lblBB)
                    
                    let lblHS = UILabel(frame: CGRect(x: view.frame.size.width - (view.frame.size.width)/9, y: 1, width: 50, height: 20))
                    lblHS.textColor = UIColor.whiteColor()
                    lblHS.font = UIFont.systemFontOfSize(12)
                    lblHS.text = "+/-"
                    subView.addSubview(lblHS)
                    
                    let lblPoint = UILabel(frame: CGRect(x: view.frame.size.width - (view.frame.size.width)/19, y: 1, width: 50, height: 20))
                    lblPoint.textColor = UIColor.whiteColor()
                    lblPoint.font = UIFont.systemFontOfSize(12)
                    lblPoint.text = AL0604.localization(LanguageKey.label_total_point)
                    subView.addSubview(lblPoint)
                }else{
                    view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
                    view.backgroundColor = UIColor(rgba: "#595858")
                    let lblMatch = UILabel(frame: CGRect(x: view.frame.size.width - (view.frame.size.width)/2.7 , y: 10, width: 50, height: 20))
                    lblMatch.textColor = UIColor.whiteColor()
                    lblMatch.font = UIFont.systemFontOfSize(11)
                    lblMatch.text = AL0604.localization(LanguageKey.label_total_match)
                    
                    view.addSubview(lblMatch)
                    
                    let lblWin = UILabel(frame: CGRect(x: view.frame.size.width - (view.frame.size.width)/3.25, y: 10, width: 50, height: 20))
                    lblWin.textColor = UIColor.whiteColor()
                    lblWin.font = UIFont.systemFontOfSize(11)
                    lblWin.text = AL0604.localization(LanguageKey.label_total_win)
                    view.addSubview(lblWin)
                    
                    let lblDraw = UILabel(frame: CGRect(x: view.frame.size.width - (view.frame.size.width)/3.95, y: 10, width: 50, height: 20))
                    lblDraw.textColor = UIColor.whiteColor()
                    lblDraw.font = UIFont.systemFontOfSize(11)
                    lblDraw.text = AL0604.localization(LanguageKey.label_total_draw)
                    view.addSubview(lblDraw)
                    
                    let lblLose = UILabel(frame: CGRect(x: view.frame.size.width - (view.frame.size.width)/5.25, y: 10, width: 50, height: 20))
                    lblLose.textColor = UIColor.whiteColor()
                    lblLose.font = UIFont.systemFontOfSize(11)
                    lblLose.text = AL0604.localization(LanguageKey.label_total_lose)
                    view.addSubview(lblLose)
                    
                    let lblHS = UILabel(frame: CGRect(x: view.frame.size.width - (view.frame.size.width)/7.2, y: 10, width: 50, height: 20))
                    lblHS.textColor = UIColor.whiteColor()
                    lblHS.font = UIFont.systemFontOfSize(11)
                    lblHS.text = "+/-"
                    view.addSubview(lblHS)
                    
                    let lblPoint = UILabel(frame: CGRect(x: view.frame.size.width - (view.frame.size.width)/15.5, y: 10, width: 50, height: 20))
                    lblPoint.textColor = UIColor.whiteColor()
                    lblPoint.font = UIFont.systemFontOfSize(11)
                    lblPoint.text = AL0604.localization(LanguageKey.label_total_point)
                    view.addSubview(lblPoint)
                }
            }
        supperView.addSubview(view)
        return supperView
    }
    
}
extension L3sMatchRankingView: UITableViewDelegate{
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Giải đấu Quốc Gia
        if self.leageRankRounds != nil {
            
            return 60
            
            // Giải đấu cúp
        }else{
            
            if self.isTypeMatch{
                return 0
            }else if self.isTypeGroup{
                if section == 0{
                    return 21
                }else{
                    return 31
                }
                
            }else{
                return 40
            }
            
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Giải đấu Quốc Gia
        if self.leageRankRounds != nil {
            return 44
            
            // Giải đấu cúp
        }else{
            
            if self.isTypeMatch{
                return 55
            }else if self.isTypeGroup{
                return 21
            }else{
                return 44
                
            }
            
        }
    }
   }