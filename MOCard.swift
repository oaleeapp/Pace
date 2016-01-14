//
//  MOCard.swift
//  Pace
//
//  Created by lee on 1/8/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import Foundation
import CoreData


class MOCard: NSManagedObject {

// Insert code here to add functionality to your managed object subclass


    func addDeck(deck: MODeck) {

        self.mutableSetValueForKey("decks").addObject(deck)

    }

    func removeDeck(deck: MODeck) {

        self.mutableSetValueForKey("decks").removeObject(deck)

    }
}
