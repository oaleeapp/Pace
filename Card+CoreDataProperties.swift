//
//  Card+CoreDataProperties.swift
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

extension Card {

    @NSManaged var frontText: String?
    @NSManaged var backText: String?
    @NSManaged var proficiency: Int16
    @NSManaged var checkCount: Int64
    @NSManaged var updatedAt: NSTimeInterval
    @NSManaged var createdAt: NSTimeInterval
    @NSManaged var deck: Deck?
    @NSManaged var definition: Definition?

}
