//
//  CardSelectionTableViewController.swift
//  Pace
//
//  Created by lee on 1/9/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit
import CoreData

class CardSelectionTableViewController: UITableViewController {

    var managedObjectContext : NSManagedObjectContext?
    var deck : MODeck?
    lazy var fetchedResultsController : NSFetchedResultsController = {

        let cardFetchRequest = NSFetchRequest(entityName: MOCard.entityName())
        let primarySortDescriptor = NSSortDescriptor(key: "word.word", ascending: true)
        cardFetchRequest.sortDescriptors = [primarySortDescriptor]

        let frc = NSFetchedResultsController(fetchRequest: cardFetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)

        frc.delegate = self

        return frc

    }()

    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsMultipleSelection = true

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = .Done
        searchController.searchBar.placeholder = "find a word"

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        
    }
}

// MARK: Actions
extension CardSelectionTableViewController {

    func doneSelection() {

        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)

    }

}

// MARK: - TableView DataSource Delegate
extension CardSelectionTableViewController {

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
        didSelectedAtIndexPath(indexPath)

    }

    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
}

// MARK: searchResultsUpdater
extension CardSelectionTableViewController : UISearchResultsUpdating {

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            print("has no searchBar.Text")
            return
        }

        if searchString.characters.count == 0 {
            searchWordAll()
        } else {
            searchWord(searchString)
        }

    }
}


// MARK: searchBar delegate 
extension CardSelectionTableViewController : UISearchBarDelegate {

}


// MARK: - NSFetchedResultsControllerDelegate
extension CardSelectionTableViewController : NSFetchedResultsControllerDelegate{

    func searchWord(word: String){

        let predicate = NSPredicate(format: "word.word CONTAINS[cd] %@", word)
        fetchedResultsController.fetchRequest.predicate = predicate

        do{
            try fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch {
            print("\(error)")
        }

    }

    func searchWordAll() {

        fetchedResultsController.fetchRequest.predicate = nil
        do{
            try fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch {
            print("\(error)")
        }
    }

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
        cell.textLabel?.text = card.word?.word
        guard let inDeck = card.decks?.containsObject(self.deck!) else {
            return cell
        }

        if inDeck {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }

        return cell
    }

    func didSelectedAtIndexPath(indexPath: NSIndexPath) {
        let card = fetchedResultsController.objectAtIndexPath(indexPath) as! MOCard
        guard let inDeck = card.decks?.containsObject(self.deck!) else {
            return
        }

        if inDeck {
            card.removeDeck(self.deck!)
        } else {
            card.addDeck(self.deck!)
        }
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
