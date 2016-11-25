//
//  StatisticViewController.swift
//  Live3s
//
//  Created by phuc on 11/30/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SessionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var statisticCountry: StatisticCountry?
    var bannerView: GADBannerView?
     var interstitial: GADInterstitial!
    private var arraySession: [StatisticSession]? = [StatisticSession](){
        didSet {
            
            self.tableView.reloadData()
            self.isReloadingData = false
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
        getDataFromServer((self.statisticCountry?.id)!)
        self.addAvertisingFull()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDataFromServer(coutry_id:String) {
        if isReloadingData {return}
        isReloadingData = true
        NetworkService.getLeagueOfCountry(coutry_id) { (leagues, error) -> () in
            if error == nil {
                if let arrayLeague = leagues {
                    if arrayLeague.count > 0 {
                        for leagueJSON in arrayLeague {
                            let leagueOBJ = StatisticSession(json: leagueJSON)
                            self.arraySession?.append(leagueOBJ);
                        }
                    }else{
                        let alert = UIAlertController(title: AL0604.localization(LanguageKey.alert), message:AL0604.localization(LanguageKey.no_data), preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: AL0604.localization(LanguageKey.cancel), style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        self.isReloadingData = false
                    }
                    
                }else{
                    let alert = UIAlertController(title: AL0604.localization(LanguageKey.alert), message:AL0604.localization(LanguageKey.no_data), preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: AL0604.localization(LanguageKey.cancel), style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.isReloadingData = false
                }
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

//MARK: - SesionTableViewCellDelegate
extension SessionViewController: SesionTableViewCellDelegate {
    func actionFavorite(cell: SesionTableViewCell) {
        var favorite = seasonfavoriteList()
        let id = cell.season!.id!
        if let index = favorite.indexOf(id) {
            favorite.removeAtIndex(index)
            cell.imgFavorite.image = UIImage(named: "icon_favorite.png")
        } else  {
            favorite.append(cell.season!.id!)
            cell.imgFavorite.image = UIImage(named: "icon_favorited.png")
        }
        setSeasonfavoriteList(favorite)
    }
}
//MARK - UITableViewDatasource
extension SessionViewController: UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            if let countSeason = arraySession?.count{
                return countSeason
            }else {
                return 0
            }

    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SessionCell") as! SesionTableViewCell
        cell.selectionStyle = .None
        let sessionOBJ:StatisticSession = arraySession![indexPath.row]
         cell.season = sessionOBJ
        if indexPath.row % 2 == 0{
            cell.backgroundColor = UIColor.whiteColor()
            
        }else{
            cell.backgroundColor = UIColor(rgba: "#f5f5f5")
        }
        cell.delegate = self
        let url = NSURL(string: statisticCountry!.country_logo!)
        cell.imgFlag.af_setImageWithURL(url!)
        return cell
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lgFrame = CGRect(x: 0, y: 0, width: tableView.frame.size.width , height: 30)
        let view = UIView(frame:lgFrame)
        view.backgroundColor = UIColor(red: 89/255, green: 88/255, blue: 88/255, alpha: 1.0)
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 5, width: self.view.frame.size.width, height: 20))
        titleLabel.font = UIFont.systemFontOfSize(14)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        if let strTitle = self.statisticCountry?.name{
                titleLabel.text = strTitle
        }
        view.addSubview(titleLabel)
        return view
    }
    
    
}
// MARK: - GADInterstitialDelegate
extension SessionViewController: GADInterstitialDelegate{
    func interstitialDidReceiveAd(ad: GADInterstitial!){
        if self.interstitial.isReady {
            self.interstitial.presentFromRootViewController(self)
        }
        
    }
}

//MARK - UITableViewDelegate
extension SessionViewController: UITableViewDelegate{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailVC =  storyboard?.instantiateViewControllerWithIdentifier("DetailStatisticViewController") as! DetailStatisticViewController
        let leagueSelect = self.arraySession![indexPath.row]
        detailVC.leagueID = leagueSelect.id
        detailVC.urlLogo = self.statisticCountry?.country_logo
        detailVC.isRank = true
        detailVC.isMatch = false
        detailVC.isIndex = false
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
}
//MARK - StatisticCell
protocol SesionTableViewCellDelegate: NSObjectProtocol {
    func actionFavorite(cell: SesionTableViewCell)
}

class SesionTableViewCell: UITableViewCell{
    
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgFavorite: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var season: StatisticSession? {
        didSet {

                lblTitle.text = season?.name
                let favorite = seasonfavoriteList()
            if favorite.contains(season!.id!) {
                imgFavorite.image = UIImage(named: "icon_favorited.png")
            } else {
                imgFavorite.image = UIImage(named: "icon_favorite.png")
            }
        }
    }
    var delegate: SesionTableViewCellDelegate?
    
    @IBAction func favoriteButtonPress(sender: AnyObject) {
        self.delegate?.actionFavorite(self)
    }
}

