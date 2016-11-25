//
//  RelatedViewController.swift
//  Live3s
//
//  Created by codelover2 on 13/12/2015.
//  Copyright © Năm 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class RelatedViewController : L3sViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var bannerView: GADBannerView?
    var appArray:[RelatedAppOBJ] = [RelatedAppOBJ](){
        didSet {
            tableView.reloadData()
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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Related App")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        self.addAvertising()
        LoadingView.sharedInstance.showLoadingView(view)
        getRelatedAppFromServer()
        
    }
    override func viewDidLoad() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .None
      
        
        super.viewDidLoad()
        addLeftBarButtonWithImage(UIImage(named: "icon_menu.png")!)
        
        // Do any additional setup after loading the view.
    }
    func getRelatedAppFromServer() {
        if isReloadingData {return}
        isReloadingData = true
        NetworkService.getRelatedApp { (relatedApps, error) -> Void in
            if error == nil {
                if let array = relatedApps {
                    self.appArray = array
                }

            }else{
                 self.isReloadingData = false
            }
        }
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
}
// MARK - Tableview Datasource
extension RelatedViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return appArray.count;
       
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RelatedCell") as! RelatedTablewViewCell
         let obj:RelatedAppOBJ = appArray[indexPath.row]
            cell.titleApp.text = obj.name
        if let urlString: String = obj.icon {
            let url = NSURL(string: urlString)!
           cell.iconApp.af_setImageWithURL(url)
        }
        if indexPath.row % 2 == 0{
            cell.backgroundColor = UIColor.whiteColor()
            
        }else{
            cell.backgroundColor = UIColor(rgba: "#f5f5f5")
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let obj:RelatedAppOBJ = appArray[indexPath.row]
        let url = NSURL(string:obj.link)
        UIApplication.sharedApplication().openURL(url!)

    }

}

// MARK - Reladted TableViewCell

class RelatedTablewViewCell: UITableViewCell {
    
    @IBOutlet weak var iconApp: UIImageView!
    @IBOutlet weak var titleApp: UILabel!
}
