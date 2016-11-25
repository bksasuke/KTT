//
//  L3sTipDetailViewController.swift
//  Live3s
//
//  Created by phuc on 2/2/16.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import UIKit
import GoogleMobileAds
class L3sTipDetailViewController: UIViewController {

    /**
     IBOutlet
     */
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vScrollContent: UIView!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var lbHaflTime: UILabel!
    @IBOutlet weak var lbHomeName: UILabel!
    @IBOutlet weak var lbAwayName: UILabel!
    @IBOutlet weak var iconHome: UIImageView!
    @IBOutlet weak var iconAway: UIImageView!
    @IBOutlet weak var lbRecentHeader: UILabel!
    @IBOutlet weak var lbTipHeader: UILabel!
    @IBOutlet weak var lbPickHeader: UILabel!
    @IBOutlet weak var lbTipDetail: UILabel!
    @IBOutlet weak var lbPickDetail: UILabel!
    @IBOutlet weak var constraintTipDetailHeight: NSLayoutConstraint!
    
    @IBOutlet weak var constraintVScrollContent: NSLayoutConstraint!
    var tip: TipsModule!
     var interstitial: GADInterstitial!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        LoadingView.sharedInstance.showLoadingView(view)
        setupUI()
        self.addAvertisingFull()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupUI() {
        
        lbScore.layer.cornerRadius = 5
        lbScore.clipsToBounds = true
        if tip.is_finish == 2 {
            
            lbScore.text = "vs"
        } else {
            if tip.time_start > NSDate().timeIntervalSince1970 {
                lbScore.text = "vs"
                LoadingView.sharedInstance.hideLoadingView()
                LoadingView.sharedInstance.showTextInView(vScrollContent, text: "No data")
            } else {
                lbScore.text = "vs"
            }
        }
        var chars = Array(tip.home_form.characters)
        chars.appendContentsOf(Array(tip.away_form.characters))
        for i in 1...chars.count {
            var img: UIImage!
            if chars[i - 1] == "W" {
                img = UIImage(named: "w.png")
            } else if chars[i - 1] == "D" {
                img = UIImage(named: "D.png")
            } else {
                img = UIImage(named: "L.png")
            }
            let image = vScrollContent.viewWithTag(i) as! UIImageView
            image.image = img
        }
        
        for aindex in 11...15 {
            let imgView = vScrollContent.viewWithTag(aindex) as! UIImageView
            if (aindex % 10) <= tip.count_star {
                imgView.image = UIImage(named: "Favorite.png")
            } else {
                imgView.image = UIImage(named: "Favorite_black.png")
            }
        }
        lbHomeName.text = tip.home_club_name
        lbAwayName.text = tip.away_club_name
        lbPickDetail.text = tip.pick
        lbTipDetail.text = tip.tip
        let width = vScrollContent.frame.width
        let font = UIFont.systemFontOfSize(12)
        let height = lbTipDetail.text!.heightWithConstrainedWidth(width, font: font)
        constraintTipDetailHeight.constant = height + 20
        constraintVScrollContent.constant = 200 + constraintTipDetailHeight.constant
        scrollView.contentSize = CGSize(width: width, height: constraintVScrollContent.constant + 40)
        LoadingView.sharedInstance.hideLoadingView()
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

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}
// MARK: - GADInterstitialDelegate
extension L3sTipDetailViewController: GADInterstitialDelegate{
    func interstitialDidReceiveAd(ad: GADInterstitial!){
        if self.interstitial.isReady {
            self.interstitial.presentFromRootViewController(self)
        }
        
    }
}