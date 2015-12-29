//
//  Synonym+CoreDataProperties.swift
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

extension Synonym {

    @NSManaged var text: String?
    @NSManaged var definition: Definition?

}
