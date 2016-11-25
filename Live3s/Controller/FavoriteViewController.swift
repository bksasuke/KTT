//
//  FavoriteViewController.swift
//  Live3s
//
//  Created by phuc on 11/30/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import UIKit
import Foundation
import GoogleMobileAds

// MARK: - local store datasource
//MARK: - match favorite
func getMatchfavoriteList() -> [MatchModle] {
    return MatchModle.allsavedMatch()
}
func setMatchfavoriteList(list: [String]) {
    NSUserDefaults.standardUserDefaults().setObject(list, forKey: "matchfavoriteList")
}

let teamfavoriteList: [String] = {
    if let result = NSUserDefaults.standardUserDefaults().objectForKey("teamfavoriteList") {
        return result as! [String]
    } else {
        return [String]()
    }
}()
func setteamfavoriteList(list: [String]) {
    NSUserDefaults.standardUserDefaults().setObject(list, forKey: "teamfavoriteList")
}

func seasonfavoriteList() -> [String] {
    if let result = NSUserDefaults.standardUserDefaults().objectForKey("seasonfavoriteList") {
        return result as! [String]
    } else {
        return [String]()
    }
}
func setSeasonfavoriteList(list: [String]) {
    NSUserDefaults.standardUserDefaults().setObject(list, forKey: "seasonfavoriteList")
}


class FavoriteViewController: L3sViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var bannerView: GADBannerView?
     var interstitial: GADInterstitial!
    internal var isShowFull:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "addAvertising", name: ADD_AD, object: nil)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Favorite")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        tableView.separatorStyle = .None
        tableView.reloadData()
        addLeftBarButtonWithImage(UIImage(named: "icon_menu.png")!)
        self.addAvertising()
        self.addAvertisingFull()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UPDATE_DATA, object: nil)
    }
    func updateDataTable(){
        self.tableView .reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addAvertising() {
        if let appDeleteAD = L3sAppDelegate.adBanner{
            if appDeleteAD.visible == "true"{
                let bannerFrame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
                bannerView = GADBannerView(frame: bannerFrame)
                bannerView!.adUnitID = appDeleteAD.id;
                bannerView!.rootViewController = self;
                let request:GADRequest = GADRequest();
                // Enable test ads on simulators.
                request.testDevices = [kGADSimulatorID];
                self.view.addSubview(bannerView!)
                bannerView?.loadRequest(request)
            }
        }

    }

    func addAvertisingFull(){
        if self.isShowFull{
            if let appDeleteADFull = L3sAppDelegate.adFull{
                if appDeleteADFull.visible == "true"{
                    let varial = arc4random_uniform(100) + 1
                    if Int(varial) < Int(appDeleteADFull.rate){
                        self.interstitial = GADInterstitial(adUnitID: appDeleteADFull.id)
                        let request = GADRequest()
                        // Requests test ads on test devices.
                        request.testDevices = [kGADSimulatorID];
                        self.interstitial.loadRequest(request)
                        self.interstitial.delegate = self
                    }
                }
            }
        }
    }
}

//MARK: - SesionTableViewCellDelegate
extension FavoriteViewController: FavoriteSeasonTableViewCellDelegate {
    func actionFavorite(cell: FavoriteSeasonTableViewCell) {
        var favorite = seasonfavoriteList()
        let id = cell.season!.id!
        if let index = favorite.indexOf(id) {
            favorite.removeAtIndex(index)
            cell.imgFavorite.image = UIImage(named: "icon_favorite_black.png")
        } else  {
            favorite.append(cell.season!.id!)
            cell.imgFavorite.image = UIImage(named: "icon_favorited_black.png")
        }
        setSeasonfavoriteList(favorite)
        tableView.reloadData()
    }
}
// MARK: - GADInterstitialDelegate
extension FavoriteViewController: GADInterstitialDelegate{
    func interstitialDidReceiveAd(ad: GADInterstitial!){
        if self.interstitial.isReady {
            self.interstitial.presentFromRootViewController(self)
            self.isShowFull = false
        }
        
    }
}
extension FavoriteViewController: FavoriteMatchTableViewCellDelegate {
    func actionFavoriteMatch(cell: FavoriteMatchTableViewCell) {
        L3sAppDelegate.managedObjectContext.deleteObject(cell.match!)
        try! L3sAppDelegate.managedObjectContext.save()
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource
extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    //MatchCell
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return getMatchfavoriteList().count
        } else {
            return seasonfavoriteList().count
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("SessionCell") as! FavoriteSeasonTableViewCell
            let id = seasonfavoriteList()[indexPath.row]
            if let season = Season.findByID(id) {
                cell.season = StatisticSession(season: season)
            }
            cell.delegate = self
            
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteMatchTableViewCell") as! FavoriteMatchTableViewCell
        cell.delegate = self
        cell.match = getMatchfavoriteList()[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewFrame = CGRectMake(0, 0, tableView.frame.width, 20)
        let view = UILabel(frame: viewFrame)
        view.textAlignment = .Center
        view.backgroundColor = UIColor(rgba: "#1a1a1a")
        view.textColor = UIColor.whiteColor()
        view.font = UIFont.boldSystemFontOfSize(14)
        if section == 0 {
            view.text = AL0604.localization(LanguageKey.favorite_my_score)
        } else {
            view.text = AL0604.localization(LanguageKey.favorite_my_competitions)
        }
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let matchDetailVC = L3sMatchDetailViewController(nibName: "L3sMatchDetailViewController", bundle: nil)
            let match = getMatchfavoriteList()[indexPath.row]
            matchDetailVC.matchModel = match
            navigationController?.pushViewController(matchDetailVC, animated: true)
        } else {
            let id = seasonfavoriteList()[indexPath.row]
            if let season = Season.findByID(id) {
                let sesion =  StatisticSession(season: season)
                let detailVC =  storyboard?.instantiateViewControllerWithIdentifier("DetailStatisticViewController") as!DetailStatisticViewController
                detailVC.leagueID = sesion.id
                detailVC.isRank = true
                detailVC.isMatch = false
                detailVC.isIndex = false
                navigationController?.pushViewController(detailVC, animated: true)
        }
        }
    }
}


// MARK: - FavoriteMatch tableview cell

protocol FavoriteMatchTableViewCellDelegate: NSObjectProtocol{
    func actionFavoriteMatch(cell: FavoriteMatchTableViewCell)
}

class FavoriteMatchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currentTimeButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var awayLabel: UILabel!
    var delegate: FavoriteMatchTableViewCellDelegate?
    
    var match: MatchModle? {
        didSet {
            guard let match = match else {
                fatalError("cannot setup cel with nil value")
            }
            
            for updateOBJ in L3sAppDelegate.arrayUpdate {
                if match.id == updateOBJ.match_id {
                    match.status = updateOBJ.status
                    match.home_goal = updateOBJ.home_goal
                    match.away_goal = updateOBJ.away_goal
                    match.home_goalH1 = updateOBJ.home_goalH1
                    match.away_goalH1 = updateOBJ.away_goalH1
                }
            }
            
            
            if Double(match.time_start!) > NSDate().timeIntervalSince1970 {
                let text = DateManager.shareManager.dateToString(match.time_start!.doubleValue, format: "HH:mm")
                resultButton.setTitle(text, forState: .Normal)
                currentTimeButton.hidden = true
            } else {
                currentTimeButton.hidden = false
                if let status = match.status {
                    currentTimeButton .setTitle(status, forState: .Normal)
                }else{
                    currentTimeButton .setTitle("Live", forState: .Normal)
                }
                resultButton.setTitle("\(match.home_goal!) - \(match.away_goal!)", forState: .Normal)
            }

                homeLabel.text = match.home_club_name
                awayLabel.text = match.away_club_name
            favoriteButton.setImage(UIImage(named: "icon_favorited_black.png"), forState: .Normal)
        }
    }
    
    override func layoutSubviews() {
        currentTimeButton.layer.cornerRadius = 5
        resultButton.layer.cornerRadius = 5
        favoriteButton.layer.cornerRadius = 5
        
    }
    
    @IBAction func favoriteButtonHandle(sender: AnyObject) {
        self.delegate?.actionFavoriteMatch(self)
    }
    
    
}


//MARK: - FavoriteSeason tableview cell
protocol FavoriteSeasonTableViewCellDelegate: NSObjectProtocol {
    func actionFavorite(cell: FavoriteSeasonTableViewCell)
}

class FavoriteSeasonTableViewCell: UITableViewCell {
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgFavorite: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var season: StatisticSession? {
        didSet {
            lblTitle.text = season?.name
            let favorite = seasonfavoriteList()
            let url = NSURL(string: season!.league_logo!)
            let placeholderImage = UIImage(named: "bg_headerRate.png")
            imgFlag.af_setImageWithURL(url!, placeholderImage: placeholderImage)
            if favorite.contains(season!.id!) {
                imgFavorite.image = UIImage(named: "icon_favorited_black.png")
            } else {
                imgFavorite.image = UIImage(named: "icon_favorited_black.png")
            }
        }
    }
    var delegate: FavoriteSeasonTableViewCellDelegate?
    
    @IBAction func favoriteButtonPress(sender: AnyObject) {
        self.delegate?.actionFavorite(self)
    }
    
}
