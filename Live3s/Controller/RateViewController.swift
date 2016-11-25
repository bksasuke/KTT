//
//  RateViewController.swift
//  Live3s
//
//  Created by phuc on 11/30/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import UIKit
import GoogleMobileAds

class PaddingLabel: UILabel {
    var padding: CGFloat = 5
    override func drawTextInRect(rect: CGRect) {
        let insets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
}

class RateViewController: L3sViewController {
    
    @IBOutlet weak var lblTaixiu: UILabel!
    @IBOutlet weak var lblDoibong: UILabel!
    @IBOutlet weak var lblChap: UILabel!
@IBOutlet weak var tableview: UITableView!
@IBOutlet weak var headerScroll: ScrollPager!
    private var headerView = [MatchDayButton]()
    private var selectedDropDownIndex: Int = 0
    private var selectedHeaderIndex: Int = 0
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
    private var datasource: [RateSeason]? {
        didSet {
            
            self.tableview.reloadData()
            self.isReloadingData = false
        }
    }
    var bannerView: GADBannerView?
     var interstitial: GADInterstitial!
    internal var isShowFull:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingView.sharedInstance.showLoadingView(view)
        self.view.backgroundColor = UIColor.blackColor()
        self.tableview.dataSource=self;
        self.tableview.delegate=self;
        self.tableview.separatorStyle = .None
        addLeftBarButtonWithImage(UIImage(named: "icon_menu.png")!)
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Odds")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        

        self.lblDoibong.text = AL0604.localization(LanguageKey.team)
        self.lblChap.text = AL0604.localization(LanguageKey.chap)
        self.lblTaixiu.text = AL0604.localization(LanguageKey.taixiu)
        self.addAvertising()
        self.addAvertisingFull()
        self.getDataFromServer()
        updateUI()
        headerScroll.selectedIndex = middleItem
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
      
        if isFirstTime {
              setUpHeader()
            isFirstTime = false
        }
    }
    func updateUI() {
        
        
        self.tableview.reloadData()
        for button in headerView {
            button.layoutSubviews()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setUpHeader() {
        let currentDate = NSDate().timeIntervalSince1970
        let firstheaderDate = currentDate - Double(86400 * middleItem)
        for index in 0...(maxItem - 1) {
            let timeinterval = firstheaderDate + Double(index * 86400)
            let aDate = NSDate(timeIntervalSince1970: timeinterval)
            let components = DateManager.shareManager.dateComponentFromString(aDate, format: "dd-MM-yyyy")
            let view = MatchDayButton(frame: CGRectZero)
            view.title = "\(components.day)-\(components.month)-\(components.year)"
            view.subTitle = components.day
            headerView.append(view)
        }
        headerScroll.addSegmentWithViews(headerView)
        headerScroll.delegate = self
        headerScroll.selectedIndex = middleItem
        headerScroll.delegate?.scrollPagerdidSelectItem!(headerScroll, index: headerScroll.selectedIndex)

    }
    
    func getDataFromServer() {
        if isReloadingData {return}
        isReloadingData = true
        NetworkService.getRateFollowLeague({ [unowned self](matchs, error) -> () in
            if error == nil {
                guard let aMatchs = matchs else {
                    return
                }
               
                self.datasource = aMatchs
            }
        })
    }
    func getDataFromServerWithDate(date: String) {
        if isReloadingData {return}
        isReloadingData = true
        NetworkService.getRateFollowDate(date,completion: { (matchs, error) -> () in
            if error == nil {
                guard let aMatchs = matchs else {
                    return
                }
                
                self.datasource = aMatchs
            }
        })
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
extension RateViewController: GADInterstitialDelegate{
    func interstitialDidReceiveAd(ad: GADInterstitial!){
        if self.interstitial.isReady {
            self.interstitial.presentFromRootViewController(self)
            self.isShowFull = false
        }
        
    }
}
//MARK: - ScrollPgaerDelegate

extension RateViewController: ScrollPagerDelegate {
    func scrollPager(scrollPager: ScrollPager, changedIndex: Int) {
        headerView[changedIndex].selected = true
        updateButtonColor(changedIndex)
       
    }
    func scrollPagerWillChange(scrollPager: ScrollPager, fromIndex: Int) {
        headerView[fromIndex].selected = false
    }
    func scrollPagerdidSelectItem(scrollPager: ScrollPager, index: Int) {
        if index == middleItem {
            getDataFromServer()
        }else {
             getDataFromServerWithDate(headerView[index].title!)
        }
       
        
    }
    func updateButtonColor(selectedIndex: Int) {
        for index in 0..<headerView.count {
            headerView[index].type = .NoneType
        }
        if selectedIndex > 0 {
            headerView[selectedIndex - 1].type = .SemiSelectedType
        }
        if selectedIndex < (headerView.count - 1) {
            headerView[selectedIndex + 1].type = .SemiSelectedType
        }
        headerView[selectedIndex].type = .SelectedType
    }
}
//MARK - UITableViewDatasource
extension RateViewController: UITableViewDataSource{
 
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let datasouce = self.datasource {
            return datasouce.count
        } else {
            return 0
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rateSeason:RateSeason = self.datasource![section]{
            return rateSeason.matches.count;
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RateCell") as! RateTableViewCell
        cell.selectionStyle = .None
        if indexPath.row % 2 == 0 {
            cell.imgBGCell.image = UIImage(named:"bg_cellRate2.png")
        }else{
            cell.imgBGCell.image = UIImage(named:"bg_cellRate1.png")
        }
    
        if let rateSeason: RateSeason = self.datasource![indexPath.section]{
            if let rateMatchs: [RateMatch] = rateSeason.matches{
                let match = rateMatchs[indexPath.row]
                    if let intTime:Int = Int(match.time_start){
                        if let timeInterval:NSTimeInterval = NSTimeInterval(intTime){
                            let startDate = NSDate(timeIntervalSince1970:timeInterval)
                            let dateFomatter = NSDateFormatter()
                            dateFomatter.dateFormat = "HH:mm"
                            let strTime = dateFomatter.stringFromDate(startDate)
                            cell.timeLabel.text = strTime
                        }
                        
                        
                    }
                    cell.homeClubLabel.text = match.home_club_name
                    cell.awayClubLabel.text = match.away_club_name
                    cell.asiaRatioLabel.text = match.asia_ratio
                    cell.asiaRatioLabel2.text = match.asia_ratio
                    cell.asiaHomeLabel.text = match.asia_home
                    cell.asiaAwayLabel.text = match.asia_away
                    cell.totalGoalLabel.text = match.total_goal_ratio
                    cell.aboveGoalLabel.text = match.above_goal_ratio
                    cell.underGoalLabel.text = match.under_goal_ratio
                    cell.winLabel.text = match.home_win_europe_ratio
                
                    // bị lộn nên đổi lại
                    cell.drawLabel.text = match.home_lose_europe_ratio
                    cell.loseLabel.text = match.draw_europe_ratio
                
                if match.asia_side == "home"{
                    cell.asiaRatioLabel.hidden = false
                     cell.asiaRatioLabel2.hidden = true
                }else{
                    cell.asiaRatioLabel.hidden = true
                    cell.asiaRatioLabel2.hidden = false
                }
                }
            
            
        }
        
        
        return cell
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lgFrame = CGRect(x: 0, y: 0, width: tableview.frame.size.width , height: 30)
        let view = UIView(frame:lgFrame)
        view.backgroundColor = UIColor(red: 89/255, green: 88/255, blue: 88/255, alpha: 1.0)
        let flag = UIImageView(frame: CGRect(x: 10, y: 5, width: 25, height: 20))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 5, width: view.frame.size.width, height: 20))
        titleLabel.font = UIFont.boldSystemFontOfSize(14)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        if let rateSeason: RateSeason = self.datasource![section]{
            if let urlString = rateSeason.league_logo {
                let url = NSURL(string: urlString)!
                flag.af_setImageWithURL(url)
            }
            
            let seasons = Season.findByID(rateSeason.league_id!)
            titleLabel.text = seasons?.name


        }
        
        view.addSubview(titleLabel)
        view.addSubview(flag)
        return view
    }

}
//MARK - UITableViewDelegate
extension RateViewController: UITableViewDelegate{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    

}
//MARK - RateTableViewCell

class RateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgBGCell: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var homeClubLabel: UILabel!
    @IBOutlet weak var awayClubLabel: UILabel!
    @IBOutlet weak var asiaRatioLabel: UILabel!
    @IBOutlet weak var asiaRatioLabel2: UILabel!
    @IBOutlet weak var asiaHomeLabel: UILabel!
    @IBOutlet weak var asiaAwayLabel: UILabel!
    @IBOutlet weak var totalGoalLabel: UILabel!
    @IBOutlet weak var aboveGoalLabel: UILabel!
    @IBOutlet weak var underGoalLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var drawLabel: UILabel!
    @IBOutlet weak var loseLabel: UILabel!
    
    override func layoutSubviews() {
        
        timeLabel.layer.cornerRadius = 3
        timeLabel.clipsToBounds = true
        
    }
}