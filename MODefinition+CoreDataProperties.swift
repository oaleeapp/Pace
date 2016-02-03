//
//  MODefinition+CoreDataProperties.swift
//  Pace
//
//  Created by lee on 1/17/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MODefinition {

    @NSManaged var definitoin: String?
    @NSManaged var partOfSpeech: String?
    @NSManaged var colorHexString: String?
    @NSManaged var card: MOCard?
    @NSManaged var details: NSSet?
    @NSManaged var word: MOWord?
    @NSManaged var examples : [MODefinitionDetail]?
}
