//
//  DetailLiveTVViewController.swift
//  Live3s
//
//  Created by codelover2 on 25/01/2016.
//  Copyright © Năm 2016 com.phucnguyen. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
import SwiftyJSON
import Alamofire
import AlamofireImage

class DetailLiveTVViewController : UIViewController{
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lblHomeName: UILabel!
    @IBOutlet weak var lblAwayName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTiso: UILabel!
    @IBOutlet weak var lblTisoHT: UILabel!
    var isLiveTv = false
    var bannerView: GADBannerView?
     var interstitial: GADInterstitial!
    private var arrayChanel:[JSON]? = [JSON]() {
        didSet {
            self.tableview.reloadData()
        }
    }

    internal var matchLive:MatchTVOBJ?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHeader()
        self.tableview.dataSource = self;
        self.tableview.delegate = self;
        self.tableview.separatorStyle = .None
        self.tableview.estimatedRowHeight = 100
        self.tableview.rowHeight = UITableViewAutomaticDimension
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "addAvertising", name: ADD_AD, object: nil)
        self.addAvertisingFull()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        lblTisoHT.hidden = isLiveTv
        lblStatus.hidden = isLiveTv
        self.getDataFromServer()
    } 
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UPDATE_DATA, object: nil)
    }
    func updateDataTable() {
        setUpHeader()
    }
    func setUpHeader() {
        if let matchLive = self.matchLive {
            for updateOBJ in L3sAppDelegate.arrayUpdate {
                if matchLive.id == updateOBJ.match_id {
                    matchLive.status = updateOBJ.status
                    matchLive.home_goal = updateOBJ.home_goal
                    matchLive.away_goal = updateOBJ.away_goal
                    matchLive.home_goalH1 = updateOBJ.home_goalH1;
                    matchLive.away_goalH1 = updateOBJ.away_goalH1;
                }
            }
            self.lblHomeName.text = matchLive.home_club_name
            self.lblAwayName.text = matchLive.away_club_name
            if isLiveTv {
                self.lblTiso.text = "vs"
            }else{
                if matchLive.time_start > NSDate().timeIntervalSince1970 {
                    self.lblStatus.text = DateManager.shareManager.dateToString(matchLive.time_start, format: "HH:mm")
                    self.lblTiso.text = "?-?"
                    lblTisoHT.text = ""
                    self.lblTisoHT.hidden = true
                }else {
                    if matchLive.status != "" {
                        self.lblStatus.text = matchLive.status
                    }else {
                        self.lblStatus.text = "Live"
                    }
                    if matchLive.home_goal == "" {
                        matchLive.home_goal = "0"
                    }
                    
                    if matchLive.away_goal == "" {
                        matchLive.away_goal = "0"
                    }
                    self.lblTiso.text = "\(matchLive.home_goal) - \(matchLive.away_goal)"
                    let h1 = matchLive.time_start + 2700
                    if h1 <= NSDate().timeIntervalSince1970{
                        if matchLive.home_goalH1 != "" && matchLive.away_goalH1 != ""{
                            self.lblTisoHT.text =     "(HT \(matchLive.home_goalH1) - \(matchLive.away_goalH1))"
                            self.lblTisoHT.hidden = false
                        }else{
                            self.lblTisoHT.hidden = true
                        }
                        
                    }else{
                        self.lblTisoHT.hidden = true
                    }

                    
                }
                
            }

        }
    }
    
    func getDataFromServer(){
        NetworkService.getListChannel((matchLive?.id)!) { (json, error) in
            for (_,subJson):(String,JSON) in json {
                self.arrayChanel?.append(subJson)
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

// MARK: - GADInterstitialDelegate
extension DetailLiveTVViewController: GADInterstitialDelegate{
    func interstitialDidReceiveAd(ad: GADInterstitial!){
        if self.interstitial.isReady {
            self.interstitial.presentFromRootViewController(self)
        }
        
    }
}
//MARK - UITableViewDatasource
extension DetailLiveTVViewController: UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let countChannel = arrayChanel?.count{
            return countChannel
        }else {
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellTV") as! ChannelLiveTVCell
        cell.selectionStyle = .None
       
        if let json:JSON = arrayChanel?[indexPath.row]{
            if indexPath.row % 2 == 0{
                cell.backgroundColor = UIColor.whiteColor()
                cell.contentView.backgroundColor = UIColor.whiteColor()
                
            }else{
                cell.backgroundColor = UIColor(rgba: "#f5f5f5")
                cell.contentView.backgroundColor = UIColor(rgba: "#f5f5f5")
            }
            cell.lblTitle.text = json["name"].stringValue
            let logo = json["logo"].stringValue
            let url = NSURL(string: logo)
             cell.logoImage.af_setImageWithURL(url!)
            
            let arrayList = json["channels"].arrayValue ?? nil
            if arrayList?.count > 0 {
                var str = ""
                for subJson:JSON in arrayList! {
                    let strChannel = subJson["channel"].stringValue
                    str = str + "\(strChannel)\n"
                }
                cell.lblChannel.text = str
            }else{
                cell.lblChannel.text = ""
            }
        }
       
        return cell
    }
    
}

//MARK - UITableViewDelegate
extension DetailLiveTVViewController: UITableViewDelegate{
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//         if let json:JSON = arrayChanel?[indexPath.row]{
//            let arrayList = json["channels"].arrayValue ?? nil
//            if arrayList?.count > 0 {
//                if arrayList?.count == 1 {
//                    return 40
//                }else{
//                    let count = Int((arrayList?.count)!)
//                    let value = count - 1
//                    return CGFloat(value * 30)
//                }
//               
//               
//            }else{
//                return 40
//            }
//         }else{
//            return 40
//        }
//
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
}


// Mark - ChannelLiveTVCell
class ChannelLiveTVCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblChannel: UILabel!
    
    @IBOutlet weak var logoImage: UIImageView!
}