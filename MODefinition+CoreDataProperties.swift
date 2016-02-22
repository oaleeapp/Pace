//
//  MODefinition+CoreDataProperties.swift
//  Pace
//
//  Created by lee on 2/3/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MODefinition {

    @NSManaged var colorHexString: String?
    @NSManaged var definition: String?
    @NSManaged var partOfSpeech: String?
    @NSManaged var checkCount: Int64
    @NSManaged var needsShow: Bool
    @NSManaged var proficiency: Int16
    @NSManaged var details: NSSet?
    @NSManaged var word: MOWord?
    @NSManaged var decks: NSSet?

}
