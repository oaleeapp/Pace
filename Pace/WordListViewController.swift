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
    lazy var fetchedResultsController : NSFetchedResultsController = {

        let wordFetchRequest = NSFetchRequest(entityName: MOWord.entityName())
        let primarySortDescriptor = NSSortDescriptor(key: "word", ascending: true)
        wordFetchRequest.sortDescriptors = [primarySortDescriptor]

        let frc = NSFetchedResultsController(fetchRequest: wordFetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        return frc

    }()

    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = .Done
        searchController.searchBar.placeholder = "feed me new word"

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }

    }

    @IBAction func addNewWord(sender: UIBarButtonItem){
        searchController.searchBar.becomeFirstResponder()
    }
    
}
// MARK: - UISearchResultsUpdating
extension WordListViewController : UISearchResultsUpdating {
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

// MARK: - UISearchBarDelegate
extension WordListViewController : UISearchBarDelegate {

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {

    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {

        guard let word = searchBar.text else {
            print("have no word to search dictionary")
            return
        }
        
        searchController.active = false
        if word.characters.count > 0 {
            // request word dictionary
            let wordsapi = WordsApi()

            wordsapi.getWord(word){wordResult in


                do{
                    let newWord = try self.managedObjectContext!.insertWord(wordResult)
                    print("insert new word : \(newWord.word)")

                } catch {
                    
                }
            }
        }
    }

}


// MARK: - TableView DataSource Delegate
extension WordListViewController {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowInSection(section)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("wordCell", forIndexPath: indexPath)

        return configureCell(cell, indexPath: indexPath)
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let wordVC = self.storyboard?.instantiateViewControllerWithIdentifier("WordViewController") as! WordViewController
        wordVC.managedObjectContext = self.managedObjectContext
        wordVC.word = fetchedResultsController.objectAtIndexPath(indexPath) as? MOWord
        self.navigationController?.pushViewController(wordVC, animated: true)
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
        let word = fetchedResultsController.objectAtIndexPath(indexPath) as! MOWord
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
