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

    func addCard(card: MOCard){
        if self.card == nil {
            self.card = card
        }
    }

    func removeCard() {
        if self.card != nil {

            // TODO: card should remove from database
            self.card = nil
        }
    }


    func addDetail(detail : MODefinitionDetail) {

        self.mutableSetValueForKey("details").addObject(detail)
        
    }
}
