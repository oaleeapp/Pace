//
//  DeckCardsTableViewController.swift
//  Pace
//
//  Created by lee on 1/3/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit
import CoreData

class DeckCardsTableViewController: UITableViewController {

    var managedObjectContext : NSManagedObjectContext?
    var deck : MODeck?
    lazy var fetchedResultsController : NSFetchedResultsController = {

        let wordFetchRequest = NSFetchRequest(entityName: MOCard.entityName())
        let primarySortDescriptor = NSSortDescriptor(key: "definition.word.word", ascending: true)
        wordFetchRequest.sortDescriptors = [primarySortDescriptor]

        let frc = NSFetchedResultsController(fetchRequest: wordFetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)

        frc.delegate = self

        return frc
        
    }()

    func setUpManagedObjectContect(managedObjectContext: NSManagedObjectContext?, deck: MODeck?) {

        self.managedObjectContext = managedObjectContext
        self.deck = deck
        guard let deckTitle = self.deck?.title else {
            print("has no word managedObject exist")
            return
        }
        let predicate = NSPredicate(format: "ANY decks.title == %@", deckTitle)
        fetchedResultsController.fetchRequest.predicate = predicate
        do {
            try fetchedResultsController.performFetch()
            tableView?.reloadData()
        } catch {
            print("\(error)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let editBarItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editCards")
        navigationItem.rightBarButtonItems = [editBarItem]


        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }

    }

}

// MARK: Actions
extension DeckCardsTableViewController {

    func editCards() {
        let selectVC = storyboard?.instantiateViewControllerWithIdentifier("CardSelectionTableViewController") as! CardSelectionTableViewController
        selectVC.managedObjectContext = self.managedObjectContext
        selectVC.deck = self.deck

        navigationController?.pushViewController(selectVC, animated: true)

    }
}

// MARK: table data source and delegate
extension DeckCardsTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowInSection(section)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CardCell", forIndexPath: indexPath)

        return configureCell(cell, indexPath: indexPath)
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension DeckCardsTableViewController : NSFetchedResultsControllerDelegate{

    func numberOfSections() -> Int {
        guard let sectionCount = fetchedResultsController.sections?.count else {
            return 0
        }
        return sectionCount
    }

    func numberOfRowInSection(section : Int) -> Int {
        guard let sectionData = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionData.numberOfObjects
    }

    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) -> UITableViewCell {
        let card = fetchedResultsController.objectAtIndexPath(indexPath) as! MOCard
        cell.textLabel?.text = card.definition?.word?.word
        cell.detailTextLabel?.text = card.definition?.definitoin
        return cell
    }

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {

        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default: break
        }
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case .Insert:
            if let indexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                configureCell(cell!, indexPath: indexPath)
            }
            break;
        case .Move:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }

            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            break;
        }
    }
    
}

