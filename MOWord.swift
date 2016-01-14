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
    override func awakeFromInsert() {
        super.awakeFromInsert()
        self.createdAt = NSDate().timeIntervalSince1970
    }

    override func awakeFromFetch() {
        super.awakeFromFetch()
    }
}
