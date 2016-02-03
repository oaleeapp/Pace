//
//  WordDefinitionTableViewController.swift
//  Pace
//
//  Created by lee on 1/21/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit
import CoreData


class WordDefinitionTableViewController: UITableViewController {

    let cellIdentifier = "DetailCell"
    let headerViewIdentifier = "DetailHeaderView"

    @IBOutlet weak var definitionTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var definitionHeaderView: WordDefinitionHeaderView!
    var managedObjectContext : NSManagedObjectContext?
    var definition : MODefinition?
    lazy var fetchedResultsController : NSFetchedResultsController = {

        let wordFetchRequest = NSFetchRequest(entityName: MODefinitionDetail.entityName())
        let primarySortDescriptor = NSSortDescriptor(key: "key", ascending: true)
        let secondarySortDescriptor = NSSortDescriptor(key: "text", ascending: true)
        wordFetchRequest.sortDescriptors = [primarySortDescriptor,secondarySortDescriptor]




        let frc = NSFetchedResultsController(fetchRequest: wordFetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: "key", cacheName: nil)

        frc.delegate = self

        return frc
        
    }()
    weak var addAction : UIAlertAction?
    var addButton : UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpHeaderViewWithDefinition(definition!)
        tableView.estimatedRowHeight = 33.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.keyboardDismissMode = .OnDrag

        let predicate = NSPredicate(format: "definition == %@", definition!)
        fetchedResultsController.fetchRequest.predicate = predicate
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("\(error)")
        }

        addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addDetailButton:")
        navigationItem.rightBarButtonItems = [addButton!]

        tableView.registerClass(DefinitionDetailHeaderView().dynamicType, forHeaderFooterViewReuseIdentifier: headerViewIdentifier)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        adjustHeaderViewHeight()

    }





    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }




}

// MARK: Table view data source and delegate
extension WordDefinitionTableViewController {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return numberOfRowInSection(section)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WordDetailTableViewCell

        configureCell(cell, indexPath: indexPath)

        return cell
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(headerViewIdentifier) as! DefinitionDetailHeaderView
        let sectionInfo = fetchedResultsController.sections![section]
        headerView.headerTitleLabel.text = sectionInfo.name
        headerView.view.backgroundColor = UIColor(hexString: "E2E3E5")
        headerView.delegate = self
        


        return headerView
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        switch editingStyle {
        case .Delete :
            let detail = fetchedResultsController.objectAtIndexPath(indexPath) as! MODefinitionDetail
            self.managedObjectContext?.deleteObject(detail)
        default :
            return
            
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let detail = fetchedResultsController.objectAtIndexPath(indexPath) as! MODefinitionDetail

        searchWordFromDetailString(detail.text!)

    }

    func setUpHeaderViewWithDefinition(definition: MODefinition) {
        definitionHeaderView.wordLabel.text = definition.word?.word
        definitionHeaderView.definitionTextView.text = definition.definitoin
        definitionHeaderView.cardifyButton.selected = (definition.card?.needsShow)!
        definitionHeaderView.cardifyButton.addTarget(self, action: "pressCardifyButton:", forControlEvents: .TouchUpInside)
        definitionHeaderView.deleteDefinitionButton.addTarget(self, action: "pressDeleteButton:", forControlEvents: .TouchUpInside)
        definitionHeaderView.setPartOfSpeech(definition.partOfSpeech!, withColor: UIColor(hexString: definition.colorHexString!))

    }

}

// MARK:  NSFetchedResultsControllerDelegate
extension WordDefinitionTableViewController : NSFetchedResultsControllerDelegate {


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

    func configureCell(cell: WordDetailTableViewCell, indexPath: NSIndexPath) -> UITableViewCell {
        let detail = fetchedResultsController.objectAtIndexPath(indexPath) as! MODefinitionDetail

        cell.detailLabel.text = detail.text

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
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! WordDetailTableViewCell
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


// MARK: - Layout functoin
extension WordDefinitionTableViewController {

    func adjustHeaderViewHeight() {

        let newSize = definitionHeaderView.definitionTextView.sizeThatFits(definitionHeaderView.definitionTextView.frame.size)
        definitionTextViewHeightConstraint.constant = newSize.height

        let headerView = tableView.tableHeaderView!

        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()

        let height = headerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        var frame = headerView.frame
        if frame.size.height != height {
            frame.size.height = height
            headerView.frame = frame
            tableView.tableHeaderView = headerView
        }
    }



}

// MARK: - Text view delegate
extension WordDefinitionTableViewController : UITextViewDelegate {

    func textViewDidChange(textView: UITextView) {

        adjustHeaderViewHeight()
    }
}

// MARK: Editing and Creating Function
extension WordDefinitionTableViewController : WordDetailDelegate {

    func addableDetailKey() -> [String] {

        let keys = [WordsAPIDefinitionDetailType.Example.key,
                    WordsAPIDefinitionDetailType.Synonyms.key,
                    WordsAPIDefinitionDetailType.Antonyms.key,
                    WordsAPIDefinitionDetailType.SimilarTo.key]
        return keys
    }

    func addDetailButton(sender : UIBarButtonItem) {

        // show action sheet choose key

        // perform showAlertAddDetailForKey
        var actions : [UIAlertAction] = []

        for key in addableDetailKey() {

            let newAction = UIAlertAction(title: key, style: .Default, handler: { (action) -> Void in
                self.showAlertAddDetailForKey(key)
            })
            actions.append(newAction)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler : nil)
        actions.append(cancelAction)

        let actionVC = actionSheetController("New Detail", message: "select type of detail", actions: actions)

        presentViewController(actionVC, animated: true, completion: nil)

    }

    func showAlertAddDetailForKey(key: String) {

        let alertController = UIAlertController(title: key, message: nil, preferredStyle: .Alert)

        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in

            textField.placeholder = "Enter a text for \(key)"
            textField.addTarget(self, action: "textFieldDidChangeText:", forControlEvents: .EditingChanged)
        }

        addAction = UIAlertAction(title: "Done", style: .Default) { (action) -> Void in

            let text = alertController.textFields?.first?.text
            self.addDetailForKey(key, andText: text!)
        }
        addAction!.enabled = false

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler : nil)

        alertController.addAction(addAction!)
        alertController.addAction(cancelAction)

        presentViewController(alertController, animated: true, completion: nil)

    }

    func addDetailForKey(key : String, andText text: String) {

        let newDetail = MODefinitionDetail(managedObjectContext: managedObjectContext!)
        newDetail.key = key
        newDetail.text = text
        definition?.addDetail(newDetail)

    }

    func pressDeleteButton(sender : UIButton) {

        let deleteDefinitionAction = UIAlertAction(title: "Done", style: .Destructive) { (action) -> Void in
            self.deleteDefinition(self.definition!)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler : nil)

        let alertController = UIAlertController(title: "Delete this definition", message: "Are you sure to delete this definition?", preferredStyle: .Alert)
        alertController.addAction(deleteDefinitionAction)
        alertController.addAction(cancelAction)

        presentViewController(alertController, animated: true, completion: nil)

    }

    func pressCardifyButton(sender : UIButton) {

        definition?.card?.needsShow = !(definition?.card?.needsShow)!
        sender.selected = (definition?.card?.needsShow)!
    }

    func deleteDefinition(definition : MODefinition) {

        managedObjectContext?.deleteObject(definition)
        navigationController?.popViewControllerAnimated(true)

    }   

    func searchWordFromDetailString(detailString: String) {

        let words = detailString.componentsSeparatedByString(" ")

        let actionSheetController = UIAlertController(title: "Search Word", message: "pich the word to search", preferredStyle: .ActionSheet)
        for word in words {
            let action = UIAlertAction(title: word, style: .Default, handler: { (action) -> Void in
                // add or search word
                self.searchWord(word)
            })
            actionSheetController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        actionSheetController.addAction(cancelAction)

        presentViewController(actionSheetController, animated: true, completion: nil)

    }

    func searchWord(wordString: String) {


        guard wordString.characters.count != 0 else {

            print("is empty word")

            return
        }

        let fetechRequest = NSFetchRequest(entityName: MOWord.entityName())
        let sortDescriptor = NSSortDescriptor(key: "word", ascending: true)
        let predicate = NSPredicate(format: "word LIKE [cd] %@", wordString)
        fetechRequest.sortDescriptors = [sortDescriptor]
        fetechRequest.predicate = predicate

        do {
            let results = try managedObjectContext?.executeFetchRequest(fetechRequest) as! [MOWord]
            if results.count != 0 {
                let word = results.first
                pushToWord(word!)
            } else {
                let newWord = MOWord(managedObjectContext: managedObjectContext!)
                newWord.word = wordString

                // request word dictionary
                let wordsapi = WordsApi()
                wordsapi.getWord(wordString){wordResult in

                    self.managedObjectContext!.modifyWord(newWord, withWordStruct: wordResult)
                    
                }

                pushToWord(newWord)
            }


        } catch {
            print(error)
        }


    }

    func pushToWord(word: MOWord) {

        let wordVC = storyboard?.instantiateViewControllerWithIdentifier("WordViewController") as! WordViewController
        wordVC.managedObjectContext = managedObjectContext
        wordVC.word = word

        navigationController?.pushViewController(wordVC, animated: true)
    }


}


// MARK: - UITextField delegate
extension WordDefinitionTableViewController : UITextFieldDelegate {

    func textFieldDidChangeText(textField: UITextField) {

        let hasText = textField.text?.characters.count > 0
        guard let action = addAction else {
            return
        }
        action.enabled = hasText

    }
}