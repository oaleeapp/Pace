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

    let cellIdentifier = "wordCell"
    var managedObjectContext : NSManagedObjectContext?
    lazy var fetchedResultsController : NSFetchedResultsController = {

        let wordFetchRequest = NSFetchRequest(entityName: MOWord.entityName())
        wordFetchRequest.sortDescriptors = WordSearchScopeSortType.sortDescriptorsForType(.Latest)

        let frc = NSFetchedResultsController(fetchRequest: wordFetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        return frc

    }()

    var shadowImage : UIImage?

    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(WordListTableViewCell().dynamicType, forCellReuseIdentifier: cellIdentifier)

        tableView.keyboardDismissMode = .OnDrag
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.delegate = self
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = .Done
        searchController.searchBar.enablesReturnKeyAutomatically = true
        searchController.searchBar.scopeButtonTitles = WordSearchScopeSortType.scopeList()
        searchController.searchBar.alpha = 0.0
        searchController.searchBar.translucent = false
        searchController.searchBar.placeholder = "Feed me a new word, or search one..."

        hideNavigationBar(true)



        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }

    private var naviBackgroundImage : UIImage?
    private var naviBackgroundColor : UIColor?

    func hideNavigationBar(hidden: Bool) {
        if hidden {
            naviBackgroundImage = self.navigationController?.navigationBar.backgroundImageForBarMetrics(.Default)
            naviBackgroundColor = navigationController?.navigationBar.backgroundColor
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.backgroundColor = tableView.backgroundColor
        } else {
            self.navigationController?.navigationBar.setBackgroundImage(naviBackgroundImage, forBarMetrics: .Default)
            self.navigationController?.navigationBar.backgroundColor = naviBackgroundColor
            self.navigationController?.navigationBar.shadowImage = nil
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animateWithDuration(0.0) { () -> Void in
            self.searchController.active = true
        }


    }
    
}

// MARK: - word CRUD func
extension WordListViewController {

    func insertOrPushToWord(wordString: String) {

        let section = fetchedResultsController.sections?.first
        let words = section?.objects as! [MOWord]
        if let word = words.filter({word in word.word! == wordString.lowercaseString}).first {
            pushToWord(word)
        } else {
            let word = enterNewWord(wordString)
            searchController.searchBar.text = ""
            pushToWord(word)
        }
        
    }

    func enterNewWord(wordString: String) -> MOWord {

        return MOModelManager.insertWord(wordString, managedObjectContext: managedObjectContext!)
        
    }

}
//MARK: -
//MARK: - Search

//MARK: -     UISearchController delegate
extension WordListViewController : UISearchControllerDelegate {

    func didPresentSearchController(searchController: UISearchController) {

        UIView.animateWithDuration(0.0, animations: { () -> Void in
            // set NavigatoinBar back to default
            self.hideNavigationBar(false)
            searchController.searchBar.showsCancelButton = false
            }) { _ -> Void in
                UIView.animateWithDuration(0.8, animations: { () -> Void in
                    searchController.searchBar.alpha = 1.0

                })

        }
    }

}


// MARK: -     UISearchResultsUpdating
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

// MARK: -     UISearchBarDelegate
extension WordListViewController : UISearchBarDelegate {

    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchController.searchBar.showsScopeBar = true
        return true
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

        let isEnable : UIControlState = MOModelManager.validateWordString(searchBar.text!) ? .Normal : .Disabled
        let image = isEnable == .Normal ? UIImage(named: "SearchIcon") : UIImage(named: "InvalidIcon")
        searchBar.setImage(image, forSearchBarIcon: .Search, state: .Normal)
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {

        guard MOModelManager.validateWordString(searchBar.text!) else{

            showAlert(.InvalidString)
            print("invalid string for search")
            return
        }
        insertOrPushToWord(searchBar.text!)

    }

    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {

        let scopeTitle = searchBar.scopeButtonTitles![selectedScope]
        let sortType = WordSearchScopeSortType(rawValue: scopeTitle)!
        fetchedResultsController.fetchRequest.sortDescriptors = WordSearchScopeSortType.sortDescriptorsForType(sortType)

        do {
            try fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch {
            print(error)
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
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WordListTableViewCell

        return configureCell(cell, indexPath: indexPath)
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard let word = fetchedResultsController.objectAtIndexPath(indexPath) as? MOWord else {
            print("the word is invalid")
            return
        }
        pushToWord(word)
    }


    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        switch editingStyle {
        case .Delete :
            let word = fetchedResultsController.objectAtIndexPath(indexPath) as! MOWord
            self.managedObjectContext?.deleteObject(word)
        default :
            return

        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension WordListViewController : NSFetchedResultsControllerDelegate{

    func searchWord(word: String){

        let predicate = NSPredicate(format: "word CONTAINS[cd] %@", word)
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

    func configureCell(cell: WordListTableViewCell, indexPath: NSIndexPath) -> UITableViewCell {
        let word = fetchedResultsController.objectAtIndexPath(indexPath) as! MOWord
        cell.wordLebel?.text = word.word
        cell.downloadButton.rank = word.rank
        cell.downloadButton.downloadState = word.downloadState
        cell.downloadButton.addTarget(self, action: "pressDownloadButton:", forControlEvents: .TouchUpInside)
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
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! WordListTableViewCell
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

//MARK: - Navigation
extension WordListViewController {

    func pushToWord(word: MOWord) {
        let wordVC = self.storyboard?.instantiateViewControllerWithIdentifier("WordViewController") as! WordViewController
        wordVC.managedObjectContext = self.managedObjectContext
        wordVC.word = word
        self.navigationController?.pushViewController(wordVC, animated: true)
    }
}

//MAEK: - Action

extension WordListViewController {
    func pressDownloadButton(sender: UIButton) {

        let point = tableView.convertPoint(CGPoint.zero, fromView: sender)

        guard let indexPath = tableView.indexPathForRowAtPoint(point) else {
            fatalError("can't find point in tableView")
        }
        let word = fetchedResultsController.objectAtIndexPath(indexPath) as! MOWord

        switch word.downloadState {
        case .NeedsDownload:
            // download word again
            MOModelManager.downloadWord(word)
            print("")
        case .HasDownloaded:
            print("")
            if word.rank == .Undefine {
                // show actionSheet to pick a rank
                showFrequencyRankSelectSheet(word)
            }
        case .Downloading:
            break
        }
    }
}

//MARK: - Alert
extension WordListViewController {

    enum WordListAlertType {
        case InvalidString

        func title() ->String {
            switch self{
            case .InvalidString:
                return "The word is invalid"
            }
        }

        func message() ->String {
            switch self{
            case .InvalidString:
                return "Please check there is no space or puncuation"
            }
        }
    }

    func showAlert(alertType: WordListAlertType){

        let alertController = UIAlertController(title: alertType.title(), message: alertType.message(), preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)

        presentViewController(alertController, animated: true, completion: nil)

    }


    func showFrequencyRankSelectSheet(word: MOWord){

        let alertController = UIAlertController(title: "Usage-Frequency of [\(word.word!)]", message: "You can only set once.", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        for rank in FrequencyRank.rankList() {
            let rankAction = UIAlertAction(title: rank.name(), style: .Default){ _ in
                word.rank = rank
            }
            alertController.addAction(rankAction)
        }

        presentViewController(alertController, animated: true, completion: nil)
    }
}
