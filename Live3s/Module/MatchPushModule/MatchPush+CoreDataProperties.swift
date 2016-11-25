//
//  MatchPush+CoreDataProperties.swift
//  Live3s
//
//  Created by codelover2 on 05/05/2016.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MatchPush {

    @NSManaged var matchID: String?
    @NSManaged var kickoff: NSNumber?
    @NSManaged var halftime: NSNumber?
    @NSManaged var fulltime: NSNumber?
    @NSManaged var goal: NSNumber?
    @NSManaged var redcard: NSNumber?

}
