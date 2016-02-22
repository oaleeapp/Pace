//
//  MODefinition.swift
//  Pace
//
//  Created by lee on 1/8/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import Foundation
import CoreData




class MODefinition: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    func addDetail(detail : MODefinitionDetail) {

        self.mutableSetValueForKey("details").addObject(detail)
        
    }

    func addDetails(details : [MODefinitionDetail]) {
        self.mutableSetValueForKey("details").addObjectsFromArray(details)
    }

    func addDeck(deck: MODeck) {

        self.mutableSetValueForKey("decks").addObject(deck)

    }

    func removeDeck(deck: MODeck) {

        self.mutableSetValueForKey("decks").removeObject(deck)
        
    }

}
