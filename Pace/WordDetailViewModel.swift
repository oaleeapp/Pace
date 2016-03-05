//
//  WordDetailViewModel.swift
//  Pace
//
//  Created by lee on 2/16/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import Foundation
import CoreData

protocol WordDetailViewModelDelegate {

    func wordWillChange(word : MOWord)
    func wordDidChange(word: MOWord)

}

class WordDetailViewModel: NSObject {

    var managedObjectContext : NSManagedObjectContext!
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let wordFetchRequest = NSFetchRequest(entityName: MOWord.entityName())
        let primarySortDescriptor = NSSortDescriptor(key: "word", ascending: true)
        wordFetchRequest.sortDescriptors = [primarySortDescriptor]

        let frc = NSFetchedResultsController(fetchRequest: wordFetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)

        frc.delegate = self

        return frc
    }()

    var word : MOWord! 

    var delegate: WordDetailViewModelDelegate?

    convenience init(managedObjectContext: NSManagedObjectContext, word: MOWord) {

        self.init()
        self.managedObjectContext = managedObjectContext
        self.word = word
        
        let predicate = NSPredicate(format: "word == %@", word.word!)
        fetchedResultsController.fetchRequest.predicate = predicate

        do {
            // will load
            try fetchedResultsController.performFetch()
            // did load
        } catch {
            print(error)
        }
    }
}

//MARK: - NSFetchedResultsController delegate
extension WordDetailViewModel : NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        guard let delegate = self.delegate else {
            print("did not assign delegate to WordDetailViewModelDelegate")
            return
        }
        delegate.wordWillChange(word)
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        guard let delegate = self.delegate else {
            print("did not assign delegate to WordDetailViewModelDelegate")
            return
        }
        delegate.wordDidChange(word)
    }

}