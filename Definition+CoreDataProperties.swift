//
//  Definition+CoreDataProperties.swift
//  Pace
//
//  Created by lee on 12/28/15.
//  Copyright © 2015 OALeeapp. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Definition {

    @NSManaged var definitoin: String?
    @NSManaged var partOfSpeech: String?
    @NSManaged var derivation: String?
    @NSManaged var word: Word?
    @NSManaged var synonyms: NSSet?
    @NSManaged var examples: NSSet?
    @NSManaged var typeOf: NSSet?
    @NSManaged var hasTypes: NSSet?
    @NSManaged var card: Card?

}
