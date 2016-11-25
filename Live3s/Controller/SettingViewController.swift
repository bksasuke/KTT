//
//  SettingViewController.swift
//  Live3s
//
//  Created by phuc on 11/30/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SettingViewController: L3sViewController {


    @IBOutlet weak var tableView: UITableView!
    var bannerView: GADBannerView?
    
    var datasource:[LanguageModule] = [LanguageModule](){
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
    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftBarButtonWithImage(UIImage(named: "icon_menu.png")!)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Setting")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        tableView.separatorStyle = .None
        self.addAvertising()
        getDataFromServer()
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
    
    func  getDataFromServer() {
        NetworkService.getAllLanguague { (languages, error) in
            if error == nil {
                if let array = languages {
                    self.datasource = array
                }
                
            }else{
                self.isReloadingData = false
            }
        }
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingTableViewCell") as! SettingTableViewCell
        let languague:LanguageModule = datasource[indexPath.row]
        cell.selectionStyle = .None
        cell.languageText.text = languague.name
        let url = NSURL(string: languague.flag)!
        cell.flagImageView.af_setImageWithURL(url)
        if AL0604.currentLanguage == languague.code {
            cell.checkMarkImageView.hidden = false
        }else{
             cell.checkMarkImageView.hidden = true
        }

        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return AL0604.localization(LanguageKey.languages)
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let languague:LanguageModule = datasource[indexPath.row]
        AL0604.currentLanguage = languague.code
        LoadingView.sharedInstance.showLoadingView(L3sAppDelegate.window!)
        DBManager.shareInstance.initDB { (bool) in
            self.title = AL0604.localization(LanguageKey.languages)
            self.tableView.reloadData()
            LoadingView.sharedInstance.hideLoadingView()
        }
    }
}

class SettingTableViewCell: UITableViewCell {
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var languageText: UILabel!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    
    override func awakeFromNib() {
        checkMarkImageView.hidden = true
    }
    override func prepareForReuse() {
        checkMarkImageView.hidden = true
    }
    
}
