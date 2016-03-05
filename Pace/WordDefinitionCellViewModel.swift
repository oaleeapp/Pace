//
//  WordDefinitionCellViewModel.swift
//  Pace
//
//  Created by lee on 2/22/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import Foundation
import CoreData

protocol WordDefinitionCellViewModelDelegate {

    func definitionWillChange(definition: MODefinition)
    func definitionDidChange(definition: MODefinition)
    
}


class WordDefinitionCellViewModel: NSObject {

    var managedObjectContext : NSManagedObjectContext!
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let definitionFetchRequest = NSFetchRequest(entityName: MODefinition.entityName())
        let primarySortDescriptor = NSSortDescriptor(key: "definition", ascending: true)
        definitionFetchRequest.sortDescriptors = [primarySortDescriptor]

        let frc = NSFetchedResultsController(fetchRequest: definitionFetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)

        frc.delegate = self

        return frc
    }()

    var definition : MODefinition! {
        didSet{
            if oldValue.definition != definition.definition {
                fetchDefinition(definition)
                delegate?.definitionDidChange(definition)
            }
        }
    }

    var delegate: WordDefinitionCellViewModelDelegate?

    convenience init(managedObjectContext: NSManagedObjectContext, definition: MODefinition) {

        self.init()
        self.managedObjectContext = managedObjectContext
        self.definition = definition
        fetchDefinition(definition)

    }

    func fetchDefinition(definition: MODefinition) {
        let predicate = NSPredicate(format: "word == %@ && definition == %@", (definition.word)!, definition.definition!)
        fetchedResultsController.fetchRequest.predicate = predicate

        do {
            // will load
            try fetchedResultsController.performFetch()
            // did load
        } catch {
            print(error)
        }

    }


    func setNeedsShow(needsShow: Bool) {
        definition.needsShow = needsShow
    }
}

//MARK: - NSFetchedResultsController delegate
extension WordDefinitionCellViewModel : NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        guard let delegate = self.delegate else {
            print("did not assign delegate to WordDefinitionCellViewModelDelegate")
            return
        }
        delegate.definitionWillChange(definition)
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        guard let delegate = self.delegate else {
            print("did not assign delegate to WordDefinitionCellViewModelDelegate")
            return
        }
        delegate.definitionDidChange(definition)
        print("did change")
    }
    
}