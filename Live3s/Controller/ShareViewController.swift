//
//  ShareViewController.swift
//  Live3s
//
//  Created by phuc on 11/30/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import UIKit
import Social
import SafariServices
import GoogleMobileAds
import MessageUI

class ShareViewController: L3sViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    var bannerView: GADBannerView?
    var shareArray:[ShareOBJ] = [ShareOBJ](){
        didSet {
            tableview.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.dataSource = self
        self.tableview.delegate = self
        self.tableview.separatorStyle = .None
        self.createData()
        addLeftBarButtonWithImage(UIImage(named: "icon_menu.png")!)
   

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Share")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        

            self.addAvertising()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func createData() {
        let app1 = ShareOBJ(title:"Facebook", image: "fb.png")
        shareArray.append(app1)
        let app2 = ShareOBJ(title:"Gmail", image: "gm.png")
        shareArray.append(app2)
        let app3 = ShareOBJ(title:"SMS", image: "sms.png")
        shareArray.append(app3)
        let app4 = ShareOBJ(title:"Google plus", image: "googleplus.png")
        shareArray.append(app4)
        let app5 = ShareOBJ(title:"Twitter", image: "twitter.png")
        shareArray.append(app5)
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
    
    func shareFacebook() {
        FaceBookManager.shareManage.shareFB(self)
    }
    
    func shareGooglePlus() {
        // Configure the sign in object.
//        let signIn = GPPSignIn.sharedInstance();
//        signIn.shouldFetchGooglePlusUser = true;
//        signIn.clientID = kGooglePlusClientID;
//        signIn.shouldFetchGoogleUserEmail = true;
//        signIn.shouldFetchGoogleUserID = true;
//        signIn.scopes = [kGTLAuthScopePlusLogin];
//        signIn.trySilentAuthentication();
//        signIn.delegate = self;
//        signIn.authenticate();
        let urlComponent = NSURLComponents(string: "https://plus.google.com/share")
        urlComponent?.queryItems = [NSURLQueryItem(name: "url", value: L3sAppDelegate.linkRateApp)]
        let url = urlComponent?.URL
        if #available(iOS 9, *) {
            let controller = SFSafariViewController(URL: url!)
            self.presentViewController(controller, animated: true, completion: nil)
        } else {
            UIApplication.sharedApplication().openURL(url!)
        }
        
    }
    
    func sendMail() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setSubject("Live 3s")
        mailComposerVC.setMessageBody("Content body.", isHTML: false)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
// MARK - Tableview Datasource
extension ShareViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return shareArray.count;
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ShareCell") as! ShareTablewViewCell
        let obj:ShareOBJ = shareArray[indexPath.row]
        cell.titleApp.text = obj.title
        cell.iconApp.image = UIImage(named:obj.image)
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if (indexPath.row == 0) {
            shareFacebook()
        } else if (indexPath.row == 1) {
            sendMail()
        } else if (indexPath.row == 2) {
            // Share SMS
        }else if (indexPath.row == 3) {
            //Share Google Plus
            shareGooglePlus()
        }else{
            // Share twitter
            shareTwitter()
            
        }
        
    }
    
    func shareTwitter(){
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let twitterShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                        twitterShare.setInitialText("Live3s")
                        twitterShare.addImage(UIImage(named: "icon.png"))
                        twitterShare.addURL(NSURL(string: L3sAppDelegate.linkRateApp))
            self.presentViewController(twitterShare, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: AL0604.localization("account"), message: AL0604.localization("alertLoginTwitter"), preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}

//extension ShareViewController: GPPSignInDelegate {
//    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
//        print("auth: \(auth)")
//        let shareDialog = GPPShare.sharedInstance().nativeShareDialog();
//        
//        // This line will fill out the title, description, and thumbnail from
//        // the URL that you are sharing and includes a link to that URL.
//        shareDialog.setTitle("Live3s", description: "Live3s", thumbnailURL: nil)
//        shareDialog.setURLToShare(NSURL(string: L3sAppDelegate.linkRateApp));
//        shareDialog.open();
//    }
//}

// MARK - Reladted TableViewCell

class ShareTablewViewCell: UITableViewCell {
    
    @IBOutlet weak var iconApp: UIImageView!
    @IBOutlet weak var titleApp: UILabel!
}

// MARK - Related Object
class ShareOBJ {
    let title:String
    let image:String
    init(title:String, image:String){
        self.title = title;
        self.image = image
        
    }
    
}