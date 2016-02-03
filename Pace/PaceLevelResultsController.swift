//
//  PaceLevelResultsController.swift
//  Pace
//
//  Created by lee on 1/14/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit
import CoreData

protocol PaceLevelDelegate {

    func levelControllerDidChangeCount(levelController: PaceLevelResultsController, fromCount: Int, toCount: Int)

}



class PaceLevelResultsController: NSFetchedResultsController {

    enum ProficiencyLevel : Int {
        case Level0 = 0
        case Level1 = 1
        case Level2 = 2
        case Level3 = 3
        case Level4 = 4
        case Level5 = 5
        case Understood = 6
    }

    var level : ProficiencyLevel
    var levelDelegate : PaceLevelDelegate
    var oldCount : Int?
    

    init(levelInt: Int, managedObjectContext: NSManagedObjectContext, levelDelegate : PaceLevelDelegate) {


        let cardFetchRequest = NSFetchRequest(entityName: MOCard.entityName())
        let primarySortDescriptor = NSSortDescriptor(key: "definition.word.word", ascending: true)
        cardFetchRequest.sortDescriptors = [primarySortDescriptor]
        let predicate = NSPredicate(format: "needsShow = TRUE && proficiency == %d", levelInt)
        cardFetchRequest.predicate = predicate
        let level = ProficiencyLevel.init(rawValue: levelInt)
        self.level = level!
        self.levelDelegate = levelDelegate

        super.init(fetchRequest: cardFetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        self.delegate = self
    }

}

extension PaceLevelResultsController : NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        guard let sectionInfo = controller.sections?.first else {

            print("controller has no section")
            return
        }

        oldCount = sectionInfo.objects?.count

    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {

    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {

        guard let sectionInfo = controller.sections?.first else {

            print("controller has no section")
            return
        }
        guard let toCount = sectionInfo.objects?.count else {

            print("controller has no new object")
            return
        }

        guard let fromCount = oldCount else {

            print("controller has no old object")
            return
        }

        levelDelegate.levelControllerDidChangeCount(self, fromCount: fromCount, toCount: toCount)
    }
}
