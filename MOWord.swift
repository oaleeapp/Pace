//
//  MOWord.swift
//  Pace
//
//  Created by lee on 1/8/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import Foundation
import CoreData


class MOWord: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
//    override func awakeFromInsert() {
//        super.awakeFromInsert()
//        self.createdAt = NSDate().timeIntervalSince1970
//    }

    // single
    func addDefinition(definition: MODefinition) {

        self.mutableSetValueForKey("definitionList").addObject(definition)

    }

    func removeDefinition(definition: MODefinition) {

        self.mutableSetValueForKey("definitionList").removeObject(definition)

    }

    // multiple
    func addDefinitions(definitions: [MODefinition]) {

        self.mutableSetValueForKey("definitionList").addObjectsFromArray(definitions)
        
    }

    func removeDefinitions(definitions: [MODefinition]) {
        for definition in definitions {
            if self.mutableSetValueForKey("definitionList").containsObject(definition) {
                self.mutableSetValueForKey("definitionList").removeObject(definition)
            }
        }

    }


}
