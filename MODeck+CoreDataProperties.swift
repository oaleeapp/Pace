//
//  MODeck+CoreDataProperties.swift
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
import UIKit

extension MODeck {

    @NSManaged var title: String?
    @NSManaged var backgroundColor: UIColor?
    @NSManaged var cards: NSSet?

}
