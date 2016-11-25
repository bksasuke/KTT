//
//  DBManager.swift
//  Live3s
//
//  Created by phuc on 12/6/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class DBManager {
    static let shareInstance = DBManager()
    
    init() {
        let lastTime = NSUserDefaults.standardUserDefaults().doubleForKey("kDBCreating")
        let needUpdateDB = (NSDate().timeIntervalSince1970 - lastTime) > 7200 ? true: false
        if needUpdateDB {
            initDB({
                if !$0 {return}
                do {
                    try L3sAppDelegate.managedObjectContext.save()
                } catch {
                    QL4("Failed to save context")
                }
            })
        }
    }
    
    func initDB(completion: (Bool) -> ()) {
        
        // create favorite
        let favorite = [
            "id": "0",
            "vi_name": "Trận đấu của tôi",
            "fr_name": "Favorite",
            "name": "Favorite"
        ]
        let favoriteJson = JSON(favorite)
        Season.createWithJson(favoriteJson)
        
        // create live
        let live = [
            "id": "999999",
            "vi_name": "Live",
            "fr_name": "Live",
            "name": "Live"
        ]
        let liveJson = JSON(live)
        Season.createWithJson(liveJson)
        
        NetworkService.getALlLeague { (json, error) -> () in
            if let json = json {
                for subJson in json {
                    Season.createWithJson(subJson)
                }
                NSUserDefaults.standardUserDefaults().setDouble(NSDate().timeIntervalSince1970, forKey: "kDBCreating")
                completion(true)
            } else {
                NSUserDefaults.standardUserDefaults().setDouble(NSDate().timeIntervalSince1970, forKey: "kDBCreating")
                completion(false)
            }
        }
    }
}