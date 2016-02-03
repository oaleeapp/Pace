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

    override func awakeFromInsert() {
        super.awakeFromInsert()
        let card = MOCard(managedObjectContext: self.managedObjectContext!)
        self.card = card
    }

    func addDetail(detail : MODefinitionDetail) {

        self.mutableSetValueForKey("details").addObject(detail)
        
    }


}
