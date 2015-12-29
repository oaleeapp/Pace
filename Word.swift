//
//  Word.swift
//  Pace
//
//  Created by lee on 12/28/15.
//  Copyright © 2015 OALeeapp. All rights reserved.
//

import Foundation
import CoreData


extension NSSortDescriptor {

    enum SortWordIdentifier : String {
        case Word = "word"
    }

    convenience init(sortWordIdentifier: SortWordIdentifier, ascending : Bool) {
        self.init(key: sortWordIdentifier.rawValue, ascending: ascending)
    }
}

extension NSPredicate {
    enum PredicateIdentifier : String {
        case IsContainString = "word CONTAINS[cd] %@"
        case IsLikeString = "word LIKE[cd] %@"
    }

    convenience init(predicateIdentifier : PredicateIdentifier, _ string: String) {
        self.init(format: predicateIdentifier.rawValue, string)
    }
}

class Word: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}
