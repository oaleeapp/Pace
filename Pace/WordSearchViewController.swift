//
//  WordSearchViewController.swift
//  Pace
//
//  Created by lee on 12/21/15.
//  Copyright © 2015 OALeeapp. All rights reserved.
//

import UIKit
import CoreData


protocol WordSearchDelegate {
    // catch selected word or action
}

class WordSearchViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var managedObjectContext: NSManagedObjectContext?
    var fetchedResultsController : NSFetchedResultsController?
    var wordTextView : UITextView?
    var fetchWordRequest = NSFetchRequest(entityNameIdentifier: .Word)

    override func viewDidLoad() {
        super.viewDidLoad()
        initFetchedController()


    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let sectionCount = fetchedResultsController?.sections?.count else {
            print("no sectioninfos")
            return 0
        }
        return sectionCount
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController?.sections?[section] else {
            print("no sectioninfo for section")
            return 0
        }
        guard let rowCount = sectionInfo.objects?.count else {
            print("no objects count")
            return 0
        }
        return rowCount
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("wordCell", forIndexPath: indexPath)
        guard let wordForCell = fetchedResultsController?.objectAtIndexPath(indexPath) as? Word else {
            print("no word")
            return cell
        }

        cell.textLabel?.text = wordForCell.word
        return cell

    }



    func initFetchedController() {

        guard let moc = managedObjectContext else {
            print("have no managedObjectContext")
            return
        }

        let wordSort = NSSortDescriptor(sortWordIdentifier: .Word, ascending: true)
        fetchWordRequest.sortDescriptors = [wordSort]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchWordRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }


}



extension WordSearchViewController : UITextViewDelegate {

    func textViewDidBeginEditing(textView: UITextView) {

    }

    func textViewDidEndEditing(textView: UITextView) {

    }

    func textViewDidChange(textView: UITextView) {

        let searchWord = textView.text
        guard searchWord.characters.count > 0 else {
            print("have no word")
            return
        }

        let fetchPredicate = NSPredicate(predicateIdentifier: .IsContainString, searchWord)


        fetchWordRequest.predicate = fetchPredicate
        do {
            try fetchedResultsController?.performFetch()
            print("success")
            tableView.reloadData()
        } catch {
            print("fetch error \(error)")
        }
    }
}








