//
//  NSManagedObject + EntityName.swift
//  Pace
//
//  Created by lee on 12/30/15.
//  Copyright © 2015 OALeeapp. All rights reserved.
//

import Foundation
import CoreData


extension NSManagedObject {

    public class func entityName() -> String {
        // NSStringFromClass is available in Swift 2.
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
}

extension NSManagedObject {

    convenience init(managedObjectContext: NSManagedObjectContext) {
        let entityName = self.dynamicType.entityName()
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedObjectContext)!
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }
}
