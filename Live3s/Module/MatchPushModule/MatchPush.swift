//
//  MatchPush.swift
//  Live3s
//
//  Created by codelover2 on 05/05/2016.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//

import Foundation
import CoreData

@objc(MatchPush)
class MatchPush: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    static func findByID(sid: String) -> MatchPush? {
        let fetchRequest = NSFetchRequest()
        let entityDes = NSEntityDescription.entityForName("MatchPush", inManagedObjectContext: L3sAppDelegate.managedObjectContext)
        fetchRequest.entity = entityDes
        fetchRequest.predicate = NSPredicate(format: "matchID = %@", sid)
        let result = try! L3sAppDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
        if result.count > 0 {
            return result.first as? MatchPush
        } else {
            return createMatchDefault(sid)
        }
        
    }
    
    static func saveMatchPush(match: MatchPush) -> Bool {
        if let savedMatch = MatchPush.findByID(match.matchID!) {
            savedMatch.kickoff = match.kickoff
            savedMatch.redcard = match.redcard
            savedMatch.goal = match.goal
            savedMatch.halftime = match.halftime
            savedMatch.fulltime = match.fulltime
            try! L3sAppDelegate.managedObjectContext.save()
            return true
        } else {
            let entity = NSEntityDescription.entityForName("MatchPush", inManagedObjectContext: L3sAppDelegate.managedObjectContext)
            let savedmatch = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: L3sAppDelegate.managedObjectContext) as! MatchPush
            savedmatch.kickoff = match.kickoff
            savedmatch.redcard = match.redcard
            savedmatch.goal = match.goal
            savedmatch.halftime = match.halftime
            savedmatch.fulltime = match.fulltime
            try! L3sAppDelegate.managedObjectContext.save()
            return true
        }
    }
    
    static func createMatchDefault(sid: String) -> MatchPush{
        let entity = NSEntityDescription.entityForName("MatchPush", inManagedObjectContext: L3sAppDelegate.managedObjectContext)
        let defaultMatch = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: L3sAppDelegate.managedObjectContext) as! MatchPush
        defaultMatch.matchID = sid
        defaultMatch.kickoff = 2
        defaultMatch.halftime = 2
        defaultMatch.fulltime = 2
        defaultMatch.goal = 2
        defaultMatch.redcard = 2
        try! L3sAppDelegate.managedObjectContext.save()
        return defaultMatch
    }

}
