//
//  MODefinitionHistory+CoreDataProperties.swift
//  Pace
//
//  Created by lee on 3/4/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MODefinitionHistory {

    @NSManaged var levelChangeAmount: Int16
    @NSManaged var updatedAt: NSTimeInterval
    @NSManaged var definition: MODefinition?

}
