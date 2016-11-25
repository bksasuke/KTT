//
//  Season.swift
//  Live3s
//
//  Created by phuc on 12/6/15.
//  Copyright © 2015 com.phucnguyen. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON


class Season: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    
    static func createWithJson(json: JSON) -> Season {
        let id = json["id"].stringValue
        if let ss = Season.findByID(id) {
            // do update
            ss.name = json["name"].stringValue
            ss.have_push = json["have_push"].stringValue
            ss.league_logo = json["league_logo"].stringValue
            return ss
        } else {
            // create new
            let entity = NSEntityDescription.entityForName("Season", inManagedObjectContext: L3sAppDelegate.managedObjectContext)
            let season = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: L3sAppDelegate.managedObjectContext) as! Season
            season.setValue(json["id"].stringValue, forKey: "id")
            season.setValue(json["name"].stringValue, forKey: "name")
            season.setValue(json["have_push"].stringValue, forKey: "have_push")
            season.setValue(json["league_logo"].stringValue, forKey: "league_logo")
            return season
        }
    
    }
    
    static func findByID(sid: String) -> Season? {
        let fetchRequest = NSFetchRequest()
        let entityDes = NSEntityDescription.entityForName("Season", inManagedObjectContext: L3sAppDelegate.managedObjectContext)
        fetchRequest.entity = entityDes
        fetchRequest.predicate = NSPredicate(format: "id = %@", sid)
        let result = try! L3sAppDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
        if result.count > 0 {
            return result.first as? Season
        } else {
            return nil
        }
    }
    
    static func findByName(string: String?, language: SupportLanguage) -> [Season]? {
        let value: String = "name"
        let fetchRequest = NSFetchRequest()
        let entityDes = NSEntityDescription.entityForName("Season", inManagedObjectContext: L3sAppDelegate.managedObjectContext)
        fetchRequest.entity = entityDes
        fetchRequest.predicate = NSPredicate(format: "%K contains[c] %@", value, string!)
        let result = try! L3sAppDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
        if result.count > 0 {
            return result as? [Season]
        } else {
            return nil
        }
    }
    
    static func unknowSeason() -> Season? {
        return Season.findByID("999999")
    }

    func localizationName() -> String? {
            return name
    }
}
