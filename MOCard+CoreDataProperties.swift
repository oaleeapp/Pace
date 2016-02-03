//
//  MOCard+CoreDataProperties.swift
//  Pace
//
//  Created by lee on 1/8/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MOCard {

    @NSManaged var checkCount: Int64
    @NSManaged var proficiency: Int16
    @NSManaged var needsShow: Bool
    @NSManaged var decks: NSSet?
    @NSManaged var definition: MODefinition?

}
