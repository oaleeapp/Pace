//
//  MODeck.swift
//  Pace
//
//  Created by lee on 1/8/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit
import CoreData


class MODeck: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    override func awakeFromInsert() {
        super.awakeFromInsert()
        self.backgroundColor = UIColor.whiteColor()
    }

}
