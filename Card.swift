//
//  Card.swift
//  Pace
//
//  Created by lee on 12/28/15.
//  Copyright © 2015 OALeeapp. All rights reserved.
//

import Foundation
import CoreData


extension NSSortDescriptor {

    enum SortCardIdentifier : String {
        case BackText = "backText"
        case CheckCount = "checkCount"
        case CreateDate = "createDate"
        case FrontText = "frontText"
        case Proficiency = "proficiency"
        case UpdateDate = "updateDate"
    }

    convenience init(sortCardIdentifier: SortCardIdentifier, ascending : Bool) {
        self.init(key: sortCardIdentifier.rawValue, ascending: ascending)
    }
}

class Card: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override func awakeFromInsert() {
        super.awakeFromInsert()
        self.createdAt = NSDate().timeIntervalSinceReferenceDate
    }

    override func awakeFromFetch() {
        super.awakeFromFetch()
        self.updatedAt = NSDate().timeIntervalSinceReferenceDate
    }
}
