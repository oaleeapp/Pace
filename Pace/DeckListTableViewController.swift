//
//  DeckListTableViewController.swift
//  Pace
//
//  Created by lee on 1/3/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit
import CoreData

class DeckListTableViewController: UITableViewController {


    var managedObjectContext : NSManagedObjectContext?
    weak var addAction : UIAlertAction?
    lazy var fetchedResultsController : NSFetchedResultsController = {

        let wordFetchRequest = NSFetchRequest(entityName: MODeck.entityName())
        let primarySortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        wordFetchRequest.sortDescriptors = [primarySortDescriptor]

        let frc = NSFetchedResultsController(fetchRequest: wordFetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)

        frc.delegate = self

        return frc

    }()

    let cellIdentifier = "deckCell"
    let cellNibName = "DeckListTableViewCell"


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Decks"
        let nib = UINib(nibName: cellNibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 74.5
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    

}

// MARK: Actions
extension DeckListTableViewController {


    @IBAction func addDeck(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New Deck", message: nil, preferredStyle: .Alert)

        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.delegate = self //REQUIRED
            textField.placeholder = "Enter a title for Deck"
            textField.addTarget(self, action: "textFieldDidChangeText:", forControlEvents: .EditingChanged)
        }

        addAction = UIAlertAction(title: "Add", style: .Default, handler: { (alertAction) -> Void in
            let text = alertController.textFields?.first?.text
            let newDeck = MODeck(managedObjectContext: self.managedObjectContext!)
            newDeck.title = text!

        })
        addAction?.enabled = false
        alertController.addAction(addAction!)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
}

// MARK: textfield delegate
extension DeckListTableViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let hasText = textField.text?.characters.count > 0
        return hasText
    }

    func textFieldDidChangeText(textField: UITextField) {
        let hasText = textField.text?.characters.count > 0
        guard let action = addAction else {
            return
        }
        action.enabled = hasText
    }


}


// MARK: table data source and delegate
extension DeckListTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowInSection(section)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DeckListTableViewCell

        return configureCell(cell, indexPath: indexPath)
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let deckVC = self.storyboard?.instantiateViewControllerWithIdentifier("DeckCardsTableViewController") as! DeckCardsTableViewController
        let deck = fetchedResultsController.objectAtIndexPath(indexPath) as? MODeck
        deckVC.setUpManagedObjectContect(self.managedObjectContext, deck: deck)
        self.navigationController?.pushViewController(deckVC, animated: true)

    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        switch editingStyle {
        case .Delete :
            let deck = fetchedResultsController.objectAtIndexPath(indexPath) as! MODeck
            self.managedObjectContext?.deleteObject(deck)
        default :
            return

        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension DeckListTableViewController : NSFetchedResultsControllerDelegate{

    func searchWord(word: String){

        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", word)
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

    func configureCell(cell: DeckListTableViewCell, indexPath: NSIndexPath) -> UITableViewCell {
        let deck = fetchedResultsController.objectAtIndexPath(indexPath) as! MODeck
        cell.deckTitleLabel?.text = deck.title
        cell.countLabel.text = "\((deck.cards?.count)!) cards"

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
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! DeckListTableViewCell
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

