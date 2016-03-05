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

        let definitionCardFetchRequest = NSFetchRequest(entityName: MODefinition.entityName())
        let primarySortDescriptor = NSSortDescriptor(key: "word.word", ascending: true)
        definitionCardFetchRequest.sortDescriptors = [primarySortDescriptor]
        let predicate = NSPredicate(format: "needsShow == 1")
        definitionCardFetchRequest.predicate = predicate

        let frc = NSFetchedResultsController(fetchRequest: definitionCardFetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)

        frc.delegate = self

        return frc

    }()

    let searchController = UISearchController(searchResultsController: nil)


    let cellIdentifier = "CardSelectCell"
    let cellNibName = "DeckCardSelectTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = deck?.title
        let nib = UINib(nibName: cellNibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0

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
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DeckCardSelectTableViewCell

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

        let predicate = NSPredicate(format: "word.word CONTAINS[cd] %@ && needsShow == 1", word)
        fetchedResultsController.fetchRequest.predicate = predicate

        do{
            try fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch {
            print("\(error)")
        }

    }

    func searchWordAll() {
        
        let predicate = NSPredicate(format: "needsShow == 1")
        fetchedResultsController.fetchRequest.predicate = predicate
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

    func configureCell(cell: DeckCardSelectTableViewCell, indexPath: NSIndexPath) -> UITableViewCell {
        let definitionCard = fetchedResultsController.objectAtIndexPath(indexPath) as! MODefinition
        cell.wordLabel.text = definitionCard.word?.word
        cell.definitionLabel.text = definitionCard.definition
        cell.partOfSpeechLabel.text = definitionCard.partOfSpeech
        guard let inDeck = definitionCard.decks?.containsObject(self.deck!) else {
            return cell
        }

        cell.tintColor = UIColor(hexString: "BA6A6D")


        if inDeck {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }

        return cell
    }

    func didSelectedAtIndexPath(indexPath: NSIndexPath) {
        let definitionCard = fetchedResultsController.objectAtIndexPath(indexPath) as! MODefinition
        guard let inDeck = definitionCard.decks?.containsObject(self.deck!) else {
            return
        }

        if inDeck {
            definitionCard.removeDeck(self.deck!)
        } else {
            definitionCard.addDeck(self.deck!)
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
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! DeckCardSelectTableViewCell
                configureCell(cell, indexPath: indexPath)
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
