//
//  MOWord+CoreDataProperties.swift
//  Pace
//
//  Created by lee on 2/17/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MOWord {

    @NSManaged var createdAt: NSTimeInterval
    @NSManaged var frequency: Double
    @NSManaged var hasDownload: Bool
    @NSManaged var pronunciation: String?
    @NSManaged var syllables: String?
    @NSManaged var word: String?
    @NSManaged var downloadStateRawValue: Int16
    @NSManaged var definitionList: NSSet?

}
