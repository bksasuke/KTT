//
//  Season+CoreDataProperties.swift
//  Live3s
//
//  Created by phuc on 2/27/16.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Season {

    @NSManaged var have_push: String?
    @NSManaged var id: String?
    @NSManaged var league_logo: String?
    @NSManaged var name: String?

}
