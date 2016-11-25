//
//  L3sLiveTvViewController.swift
//  Live3s
//
//  Created by phuc on 2/26/16.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import UIKit
import GoogleMobileAds

class L3sLiveTvViewController: L3sViewController {

    
    /**
     properties
     */
    @IBOutlet weak var tableView: UITableView!
    
    var bannerView: GADBannerView?
     var interstitial: GADInterstitial!
    internal var isShowFull:Bool = false
    private var datasource:[LeagueTVOBJ] = [LeagueTVOBJ](){
        didSet {
            tableView.reloadData()
            isReloadingData = false
        }
    }
    private var isFirstTime = true
    private var isReloadingData = false {
        didSet {
            if isReloadingData {
                LoadingView.sharedInstance.showLoadingView(view)
            } else {
                LoadingView.sharedInstance.hideLoadingView()
            }
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.separatorStyle = .None
        addLeftBarButtonWithImage(UIImage(named: "icon_menu.png")!)
        tableView.registerNib(UINib(nibName: "L3sLiveTvTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "LiveTV")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        getLiveTVFromServer()
        
        self.addAvertising()
        self.addAvertisingFull()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstTime {
            isFirstTime = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getLiveTVFromServer(){
        if isReloadingData{return}
        isReloadingData = true
        NetworkService.getLiveTV(true) { [unowned self](league, error) -> Void in
            if error == nil {
                if let leagues = league {
                    self.datasource = leagues                    
                }
            } else {
                // Show alert
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
extension L3sLiveTvViewController: GADInterstitialDelegate{
    func interstitialDidReceiveAd(ad: GADInterstitial!){
        if self.interstitial.isReady {
            self.interstitial.presentFromRootViewController(self)
            self.isShowFull = false
        }
        
    }
}
extension L3sLiveTvViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return datasource.count ?? 0
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let league = datasource[section]
        return league.matchs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! L3sLiveTvTableViewCell
        let league:LeagueTVOBJ = self.datasource[indexPath.section]
        let match:MatchTVOBJ = league.matchs[indexPath.row]
        cell.match = match
        if indexPath.row % 2 == 0{
            cell.backgroundColor = UIColor.whiteColor()
            
        } else {
            cell.backgroundColor = UIColor(rgba: "#f5f5f5")
        }
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lgFrame = CGRect(x: 0, y: 0, width: tableView.frame.size.width , height: 30)
        let view = UIView(frame:lgFrame)
        view.backgroundColor = UIColor(red: 89/255, green: 88/255, blue: 88/255, alpha: 1.0)
        let flag = UIImageView(frame: CGRect(x: 10, y: 5, width: 25, height: 20))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 5, width: view.frame.size.width, height: 20))
        titleLabel.font = UIFont.boldSystemFontOfSize(14)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        if let league: LeagueTVOBJ = self.datasource[section]{
            
            let url = NSURL(string: league.league_logo)!
            flag.af_setImageWithURL(url)
            let seasons = Season.findByID(league.league_id)
            titleLabel.text = seasons?.name
        }
        
        view.addSubview(titleLabel)
        view.addSubview(flag)
        return view
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC =  storyboard.instantiateViewControllerWithIdentifier("DetailLiveTVViewController") as! DetailLiveTVViewController
        let league:LeagueTVOBJ = self.datasource[indexPath.section]
        let match:MatchTVOBJ = league.matchs[indexPath.row]
        detailVC.matchLive = match
        detailVC.isLiveTv = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
