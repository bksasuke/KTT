//
//  FaceBookManager.swift
//  Live3s
//
//  Created by phuc on 2/5/16.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import SwiftyJSON

class FaceBookManager: NSObject {
    static let shareManage = FaceBookManager()
    
    func loginFacebook(fromViewController: UIViewController, completion: Bool ->()) {
        func facebookFetchUserInfor() {
            if let _ = FBSDKAccessToken.currentAccessToken() {
                let param = ["fields": "first_name, last_name, picture.type(large), email"]
                let reqeust = FBSDKGraphRequest(graphPath: "me", parameters: param)
                reqeust.startWithCompletionHandler({ (connection, result, error) in
                    if let _ = error {
                        // handle error
                        completion(false)
                    } else {
                        let json = JSON(result)
                        let account = Live3sAccount.getAccount()
                        account.userName = json["last_name"].stringValue + json["first_name"].stringValue
                        account.imageUrl = json["picture"]["data"]["url"].stringValue
                        account.userGold = "0"
                        account.saveAccount()
                        completion(true)
                    }
                })
            }
        }
        if let _ = FBSDKAccessToken.currentAccessToken() {
            facebookFetchUserInfor()
        } else {
            let permision = ["public_profile"]
            let login = FBSDKLoginManager()
            login.logInWithReadPermissions(permision, fromViewController: fromViewController) { (result, error) in
                if (error != nil
                    || result.isCancelled) {
                    // handle error
                    completion(false)
                } else {
                    facebookFetchUserInfor()
                }
            }
        }

    }
    
    
    func shareFB(fromViewcontroller: UIViewController) {
        
        let shareContent = FBSDKShareLinkContent()
        shareContent.contentURL = NSURL(string: L3sAppDelegate.linkRateApp)
        shareContent.contentDescription = "Sport application"
        shareContent.contentTitle = "Live3s"
        shareContent.imageURL = NSURL(string: "http://imgh.us/icon_16.png")
        let shareDialog = FBSDKShareDialog()
        shareDialog.fromViewController = fromViewcontroller
        shareDialog.shareContent = shareContent
        
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "fbauth2://")!) {
            shareDialog.mode = FBSDKShareDialogMode.Native
        } else {
            shareDialog.mode = FBSDKShareDialogMode.Automatic
        }
        shareDialog.delegate = self
        shareDialog.show()
    }
}

extension FaceBookManager: FBSDKSharingDelegate {
    @objc func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        QL2(results)
    }
    @objc func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        QL2(error)
    }
    @objc func sharerDidCancel(sharer: FBSDKSharing!) {
        QL2("User cancel share")
    }
}