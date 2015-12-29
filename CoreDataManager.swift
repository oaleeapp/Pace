//
//  CoreDataManager.swift
//  Pace
//
//  Created by lee on 12/28/15.
//  Copyright © 2015 OALeeapp. All rights reserved.
//

import Foundation
import CoreData


extension NSFetchRequest {
    enum EntityNameIdentifier : String {
        case Card = "Card"
        case Deck = "Deck"
        case Definition = "Definition"
        case Example = "Example"
        case HasType = "HasType"
        case Synonym = "Synonym"
        case Theme = "Theme"
        case TypeOf = "TypeOf"
        case Word = "Word"
    }
    convenience init(entityNameIdentifier : EntityNameIdentifier) {
        self.init(entityName: entityNameIdentifier.rawValue)
    }
}

// create fetcheRequest to view model

















