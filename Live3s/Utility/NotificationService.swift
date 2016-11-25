//
//  NotificationService.swift
//  Live3s
//
//  Created by ALWAYSWANNAFLY on 3/12/16.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import Foundation

struct NotificationService {
    
    //MARK: Public variable
    
    static let shareInstance = NotificationService()
    
    //MARK: Prvate variable
    private let kUSERDEFAULT_DEVICETOKEN = "emobi.wind.live3s_deviceToken"
    private let userDefault = NSUserDefaults.standardUserDefaults()
    
    
    //MARK: Public method
    
    func getDeviceToken() -> String? {
        return userDefault.stringForKey(kUSERDEFAULT_DEVICETOKEN)
    }
    
    func saveDeviceToken(token: String) {
        userDefault.setObject(token, forKey: kUSERDEFAULT_DEVICETOKEN)
    }
    
    func registerUserNotification() {
            let setting = UIUserNotificationSettings(forTypes: [.Alert, .Sound, .Badge], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(setting)
            UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func registerDevietokenForPushServer(token: String) {
        
        func pushTokenToServer(token: String) {
            NetworkService.registDeviceToken(token, completion: { (bool) in
                if bool {
                    self.saveDeviceToken(token)
                }
            })
        }
        
        guard let oldToken = getDeviceToken() else {
            // push new token to server
            pushTokenToServer(token)
            return
        }
        
        if oldToken == token {
            // already have token on server
            return
        } else {
            // get new token
            pushTokenToServer(token)
        }
        
    }
}