//
//  MatchModle+CoreDataProperties.swift
//  Live3s
//
//  Created by ALWAYSWANNAFLY on 6/9/16.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MatchModle {

    @NSManaged var away_club_name: String?
    @NSManaged var away_goal: String?
    @NSManaged var away_goalH1: String?
    @NSManaged var away_logo: String?
    @NSManaged var fr_away_club_name: String?
    @NSManaged var fr_home_club_name: String?
    @NSManaged var home_club_name: String?
    @NSManaged var home_goal: String?
    @NSManaged var home_goalH1: String?
    @NSManaged var home_logo: String?
    @NSManaged var id: String?
    @NSManaged var isFinish: NSNumber?
    @NSManaged var isPosponse: NSNumber?
    @NSManaged var season_id: String?
    @NSManaged var status: String?
    @NSManaged var time_start: NSNumber?
    @NSManaged var language_code: String?
    @NSManaged var memo: String?
}
