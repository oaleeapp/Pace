//
//  WordListViewController.swift
//  Pace
//
//  Created by lee on 12/31/15.
//  Copyright © 2015 OALeeapp. All rights reserved.
//

import UIKit
import CoreData

class WordListViewController: UITableViewController {

    var managedObjectContext : NSManagedObjectContext?
    var fetchWordRequest = NSFetchRequest(entityName: Word.entityName())
    lazy var fetchedResultsController : NSFetchedResultsController = {

        let wordFetchRequest = NSFetchRequest(entityName: Word.entityName())
        let primarySortDescriptor = NSSortDescriptor(key: "word", ascending: true)
        wordFetchRequest.sortDescriptors = [primarySortDescriptor]

        let frc = NSFetchedResultsController(fetchRequest: wordFetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)

        frc.delegate = self

        return frc

    }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

//MARK: - TableView DataSource Delegate
extension WordListViewController {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowForSection(section)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("wordCell", forIndexPath: indexPath)

        return configureCell(cell, indexPath: indexPath)
    }
}


// MARK: - NSFetchedResultsControllerDelegate
extension WordListViewController : NSFetchedResultsControllerDelegate{

    func searchWord(word: String){

        let predicate = NSPredicate(predicateIdentifier: .IsContainString, word)
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

    func numberOfRowForSection(section : Int) -> Int {
        guard let sectionData = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionData.numberOfObjects
    }

    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) -> UITableViewCell {
        let word = fetchedResultsController.objectAtIndexPath(indexPath) as! Word
        cell.textLabel?.text = word.word

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