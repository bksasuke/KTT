//
//  StatisticViewController.swift
//  Live3s
//
//  Created by phuc on 11/30/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import UIKit
import GoogleMobileAds

class StatisticViewController: L3sViewController {

    @IBOutlet weak var tableView: UITableView!
    var isGetCountryDone = false
    var isGetSessionDone = false
    var bannerView: GADBannerView?
     var interstitial: GADInterstitial!
    internal var isShowFull:Bool = false
    private var arraySession: [StatisticSession]? = [StatisticSession](){
        didSet {
            
            isGetSessionDone = true
            if isGetCountryDone {
                self.tableView.reloadData()
                self.isReloadingData = false
            }
            
        }
    }
    private var arrayCountry: [StatisticCountry]? = [StatisticCountry](){
        didSet {
            isGetCountryDone = true
            if isGetSessionDone {
                self.tableView.reloadData()
                self.isReloadingData = false
            }

        }
    }
    private var isReloadingData = false {
        didSet {
            if isReloadingData {
                LoadingView.sharedInstance.showLoadingView(view)
            } else {
                LoadingView.sharedInstance.hideLoadingView()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingView.sharedInstance.showLoadingView(view)
        self.tableView.separatorStyle = .None
        self.tableView.dataSource = self
        self.tableView.delegate = self
        addLeftBarButtonWithImage(UIImage(named: "icon_menu.png")!)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Statistic")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        getCoutry()
        getCommomLeagues()
        self.addAvertising()
        self.addAvertisingFull()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        bannerView?.removeFromSuperview()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCoutry(){
        NetworkService.getCountry { (countries, error) -> Void in
            if error == nil {
                if let arrayCoutries = countries{
                    self.arrayCountry = arrayCoutries
                }
            }else{
                self.isReloadingData = false
            }
        }
    }
    
    func getCommomLeagues(){
        NetworkService.getCommomLeague { (commomLeagues, error) -> Void in
            if error == nil {
                if let arrayCommomLeagues = commomLeagues{
                    self.arraySession = arrayCommomLeagues
                }
            }else{
                self.isReloadingData = false
            }
        }
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

// MARK: - GADInterstitialDelegate
extension StatisticViewController: GADInterstitialDelegate{
    func interstitialDidReceiveAd(ad: GADInterstitial!){
        if self.interstitial.isReady {
            self.interstitial.presentFromRootViewController(self)
            self.isShowFull = false
        }
        
    }
}

//MARK - UITableViewDatasource
extension StatisticViewController: UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if let countSeason = arraySession?.count{
                return countSeason
            }else {
                return 0
            }
        }else{
            if let countContry = arrayCountry?.count{
                return countContry
            }else {
                return 0
            }
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StatisticCell") as! StatisticCell
        cell.selectionStyle = .None
        cell.delegate = self
        if indexPath.section == 0 {
            cell.imgFavorite.hidden = false
            let sessionOBJ:StatisticSession = arraySession![indexPath.row]
            cell.lblTitle.text = sessionOBJ.name
            var favorite = seasonfavoriteList()
            if let _ = favorite.indexOf(sessionOBJ.id!) {
                cell.imgFavorite.image = UIImage(named: "icon_favorited.png")
            } else  {
                favorite.append(sessionOBJ.id!)
                cell.imgFavorite.image = UIImage(named: "icon_favorite.png")
            }
            let url = NSURL(string: sessionOBJ.league_logo!)
             cell.imgFlag.af_setImageWithURL(url!)
        }else {
            cell.imgFavorite.hidden = true
            let countryOBJ:StatisticCountry = arrayCountry![indexPath.row]
            cell.lblTitle.text = countryOBJ.name
            let url = NSURL(string: countryOBJ.country_logo!)
            cell.imgFlag.af_setImageWithURL(url!)
        }
        if indexPath.row % 2 == 0{
            cell.backgroundColor = UIColor.whiteColor()

        }else{
            cell.backgroundColor = UIColor(rgba: "#f5f5f5")
        }
        return cell
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lgFrame = CGRect(x: 0, y: 0, width: tableView.frame.size.width , height: 30)
        let view = UIView(frame:lgFrame)
        view.backgroundColor = UIColor(red: 89/255, green: 88/255, blue: 88/255, alpha: 1.0)
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 5, width: view.frame.size.width, height: 20))
        titleLabel.font = UIFont.systemFontOfSize(15)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        if section == 0 {
            titleLabel.text = AL0604.localization(LanguageKey.common)
        }else{
            titleLabel.text = AL0604.localization(LanguageKey.all)
        
        }
        view.addSubview(titleLabel)
        return view
    }
    
}
//MARK - UITableViewDelegate
extension StatisticViewController: UITableViewDelegate{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let detailVC =  storyboard?.instantiateViewControllerWithIdentifier("DetailStatisticViewController") as! DetailStatisticViewController
            let sessionOBJ:StatisticSession = arraySession![indexPath.row]
            detailVC.leagueID = sessionOBJ.id
            detailVC.urlLogo = sessionOBJ.league_logo
            detailVC.isRank = true
            detailVC.isMatch = false
            detailVC.isIndex = false
            navigationController?.pushViewController(detailVC, animated: true)

        }else{
            let sessionVC =  storyboard?.instantiateViewControllerWithIdentifier("SessionViewController") as! SessionViewController
            let country = arrayCountry![indexPath.row]
            sessionVC.statisticCountry = country
            navigationController?.pushViewController(sessionVC, animated: true)
        }
    }
    
}
//Mark - StatisticCellDelegate 
extension StatisticViewController: StatisticCellDelegate{
    func actionFavoriteSession(cell: StatisticCell) {
        let indexPath = self.tableView.indexPathForCell(cell)
        let season = self.arraySession![(indexPath?.row)!]
        var favorite = seasonfavoriteList()

        if let index = favorite.indexOf(season.id!) {
            favorite.removeAtIndex(index)
            cell.imgFavorite.image = UIImage(named: "icon_favorite.png")
        } else  {
            favorite.append(season.id!)
            cell.imgFavorite.image = UIImage(named: "icon_favorited.png")
        }
        setSeasonfavoriteList(favorite)
    }
}

//MARK - StatisticCell
protocol StatisticCellDelegate: NSObjectProtocol {
    func actionFavoriteSession(cell: StatisticCell)
}
class StatisticCell: UITableViewCell{

    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgFavorite: UIImageView!
    @IBOutlet weak var buttonFavorite: UIButton!
    var delegate: StatisticCellDelegate?
    @IBAction func actionFavorite(sender: AnyObject) {
        self.delegate?.actionFavoriteSession(self)
    }
    

}

