//
//  MatchModle.swift
//  Live3s
//
//  Created by phuc on 1/16/16.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import Foundation
import CoreData


class MatchModle: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    static func findByID(sid: String) -> MatchModle? {
        let fetchRequest = NSFetchRequest()
        let entityDes = NSEntityDescription.entityForName("MatchModle", inManagedObjectContext: L3sAppDelegate.managedObjectContext)
        fetchRequest.entity = entityDes
        fetchRequest.predicate = NSPredicate(format: "id = %@ AND language_code = %@", sid, AL0604.currentLanguage)
        let result = try! L3sAppDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
        if result.count > 0 {
            return result.first as? MatchModle
        } else {
            return nil
        }
        
    }
    
    static func allsavedMatch() -> [MatchModle] {
        let fetchRequest = NSFetchRequest(entityName: "MatchModle")
        var result: [MatchModle] = try! L3sAppDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as! [MatchModle]
        for match in result {
            if let startTime = match.time_start?.doubleValue {
                if (startTime < (NSDate().timeIntervalSince1970 - 7200.0)) {
                    result.removeObject(match)
                    L3sAppDelegate.managedObjectContext.deleteObject(match)
                }
            }
        }
        try! L3sAppDelegate.managedObjectContext.save()
        return result.filter({$0.language_code == AL0604.currentLanguage})
    }
    
    static func saveMatch(match: MatchModule) -> Bool {
        if let savedMatch = MatchModle.findByID(match.id) {
            L3sAppDelegate.managedObjectContext.deleteObject(savedMatch)
            return false
        } else {
            let entity = NSEntityDescription.entityForName("MatchModle", inManagedObjectContext: L3sAppDelegate.managedObjectContext)
            let savedmatch = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: L3sAppDelegate.managedObjectContext) as! MatchModle
            savedmatch.id = match.id
            savedmatch.season_id = match.season_id
            savedmatch.away_club_name = match.away_club_name
            savedmatch.away_logo = match.away_club_image
            savedmatch.away_goal = match.away_goal
            savedmatch.home_club_name = match.home_club_name
            savedmatch.home_logo = match.home_club_image
            savedmatch.home_goal = match.home_goal
            savedmatch.home_goalH1 = match.home_goalH1
            savedmatch.away_goalH1 = match.away_goalH1
            savedmatch.time_start = match.time_start
            savedmatch.isFinish = Int(match.is_finish)
            savedmatch.isPosponse = Int(match.is_postponed)
            savedmatch.status = ""
            savedmatch.memo = match.memo
            savedmatch.language_code = AL0604.currentLanguage
            try! L3sAppDelegate.managedObjectContext.save()
            return true
        }
    }
}

extension RangeReplaceableCollectionType where Generator.Element : Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}
