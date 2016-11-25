//
//  DataCache+CoreDataProperties.swift
//  Live3s
//
//  Created by codelover2 on 10/05/2016.
//  Copyright © 2016 com.phucnguyen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DataCache {

    @NSManaged var urlCache: String?
    @NSManaged var dataCache: NSData?
    @NSManaged var addedTime: NSNumber?
    @NSManaged var timeCache: NSNumber?

}
