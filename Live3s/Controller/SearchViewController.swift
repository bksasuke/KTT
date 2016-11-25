//
//  SearchViewController.swift
//  Live3s
//
//  Created by phuc on 11/30/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SearchViewController: L3sViewController {

   
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var arrayResult: [Season]? = [Season](){
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
    internal var isShowFull:Bool = false
    var bannerView: GADBannerView?
    var interstitial: GADInterstitial!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.separatorStyle = .None
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.delegate = self;
        self.tableView.tableHeaderView = nil;
        addLeftBarButtonWithImage(UIImage(named: "icon_menu.png")!)
        
      
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Search")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        self.addAvertising()
        addAvertisingFull()
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
extension SearchViewController: GADInterstitialDelegate{
    func interstitialDidReceiveAd(ad: GADInterstitial!){
        if self.interstitial.isReady {
            self.interstitial.presentFromRootViewController(self)
            self.isShowFull = false
        }

    }
}
//MARK - UITableViewDatasource
extension SearchViewController: UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            if let countSeason = arrayResult?.count{
                return countSeason
            }else {
                return 0
            }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell") as! SearchTableviewCell
        cell.delegate = self
        cell.selectionStyle = .None
        if let searchOBJ:Season = arrayResult?[indexPath.row]{
            cell.searchOBJ = searchOBJ
        }
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.whiteColor()
            
        }else{
            cell.backgroundColor = UIColor(rgba: "#f5f5f5")
        }
        return cell
    }
    
}
extension SearchViewController: SearchTableviewCellDelegate{
    func actionFavorite(cell: SearchTableviewCell) {
        var favorite = seasonfavoriteList()
        let id = cell.searchOBJ!.id!
        if let index = favorite.indexOf(id) {
            favorite.removeAtIndex(index)
            cell.imgFavorite.image = UIImage(named: "icon_favorite.png")
        } else  {
            favorite.append(cell.searchOBJ!.id!)
            cell.imgFavorite.image = UIImage(named: "icon_favorited.png")
        }
        setSeasonfavoriteList(favorite)
        tableView.reloadData()
    }
}
//MARK - UITableViewDelegate
extension SearchViewController: UITableViewDelegate{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
  
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let searchOBJ:Season = (arrayResult?[indexPath.row])!
        let detailVC =  storyboard?.instantiateViewControllerWithIdentifier("DetailStatisticViewController") as! DetailStatisticViewController
        detailVC.leagueID = searchOBJ.id
        detailVC.urlLogo = searchOBJ.league_logo
        detailVC.isRank = true
        detailVC.isMatch = false
        detailVC.isIndex = false
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
//MARK - SearchTableviewCell
protocol SearchTableviewCellDelegate: NSObjectProtocol {
    func actionFavorite(cell: SearchTableviewCell)
}
class SearchTableviewCell: UITableViewCell{
    
    @IBOutlet weak var imgFlag: UIImageView!
    var searchOBJ:Season? {
        didSet {
            lblTitle.text = searchOBJ!.localizationName()
            let url = NSURL(string: searchOBJ!.league_logo!)
            let placeholderImage = UIImage(named: "bg_headerRate.png")
            imgFlag.af_setImageWithURL(url!, placeholderImage: placeholderImage)
        }
    }
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgFavorite: UIImageView!
    var delegate: SearchTableviewCellDelegate?
    @IBAction func actionFavorite(sender: AnyObject) {
        self.delegate?.actionFavorite(self)
    }
  
    
}
//MARK - SearchBar Delegate
extension SearchViewController: UISearchBarDelegate{
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let seasons = Season.findByName(searchText, language: SupportLanguage.English)
        arrayResult = seasons
        
    }
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
        return true
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
}
//MARK - Search Object
class SearchOBJ {
    let title:String
    let id:String
    let image:String
    init(title:String, id:String, image:String){
        self.title = title;
        self.id = id
        self.image = image
        
    }
    
}

