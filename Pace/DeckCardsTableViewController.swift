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

        let definitionCardFetchRequest = NSFetchRequest(entityName: MODefinition.entityName())
        let primarySortDescriptor = NSSortDescriptor(key: "word.word", ascending: true)
        definitionCardFetchRequest.sortDescriptors = [primarySortDescriptor]

        let frc = NSFetchedResultsController(fetchRequest: definitionCardFetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)

        frc.delegate = self

        return frc
        
    }()

    let cellIdentifier = "CardCell"
    let cellNibName = "DeckCardTableViewCell"

    func setUpManagedObjectContect(managedObjectContext: NSManagedObjectContext?, deck: MODeck?) {

        self.managedObjectContext = managedObjectContext
        self.deck = deck
        guard let deckTitle = self.deck?.title else {
            print("has no word managedObject exist")
            return
        }
        let predicate = NSPredicate(format: "ANY decks.title == %@ && needsShow == 1", deckTitle)
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
        navigationItem.title = deck?.title

        let nib = UINib(nibName: cellNibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
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
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DeckCardTableViewCell

        return configureCell(cell, indexPath: indexPath)
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        selectCardAtIndexPath(indexPath)

    }

    func selectCardAtIndexPath(indexPath: NSIndexPath) {

        let definitionCard = fetchedResultsController.objectAtIndexPath(indexPath) as! MODefinition
        let definitionController = storyboard?.instantiateViewControllerWithIdentifier("WordDefinitionTableViewController") as! WordDefinitionTableViewController
        definitionController.managedObjectContext = managedObjectContext
        definitionController.definition = definitionCard
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismissDefinitionViewController:")
        definitionController.navigationItem.leftBarButtonItem = doneButton
        let naviController = UINavigationController(rootViewController: definitionController)

        presentViewController(naviController, animated: true, completion: nil)
    }

    func dismissDefinitionViewController(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
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

    func configureCell(cell: DeckCardTableViewCell, indexPath: NSIndexPath) -> UITableViewCell {
        cell.selectionStyle = .None
        let definitionCard = fetchedResultsController.objectAtIndexPath(indexPath) as! MODefinition
        cell.wordLabel.text = definitionCard.word?.word
        cell.definitionLabel.text = definitionCard.definition
        cell.partOfSpeechLabel.text = definitionCard.partOfSpeech
        cell.partOfSpeechLabel.textColor = UIColor(hexString: definitionCard.colorHexString!)
        cell.countLabel.text = "\(definitionCard.checkCount) times"
        cell.levelView.level = definitionCard.level
        return cell
    }

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        print(fetchedResultsController.sections?.first?.numberOfObjects)
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
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! DeckCardTableViewCell
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

