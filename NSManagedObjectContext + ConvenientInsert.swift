//
//  NSManagedObjectContext + ConvenientInsert.swift
//  Pace
//
//  Created by lee on 12/30/15.
//  Copyright © 2015 OALeeapp. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {

    public func insertObject<T: NSManagedObject>() -> T {
        guard let object = NSEntityDescription.insertNewObjectForEntityForName(T.entityName(), inManagedObjectContext: self) as? T
            else { fatalError("Invalid Core Data Model.") }
        return object;
    }
}