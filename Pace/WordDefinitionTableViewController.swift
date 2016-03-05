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
    lazy var addButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addDetailButton:")
    lazy var editButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editDefinition:")
    lazy var doneButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneEdit:")
    lazy var deleteButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "pressDeleteButton")

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

        navigationItem.rightBarButtonItems = [editButton, addButton]
        navigationItem.title = definition?.word?.word
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
        definitionHeaderView.definitionTextView.text = definition.definition
        definitionHeaderView.cardifyButton.selected = definition.needsShow
        definitionHeaderView.cardifyButton.addTarget(self, action: "pressCardifyButton:", forControlEvents: .TouchUpInside)
        definitionHeaderView.setPartOfSpeech(definition.partOfSpeech!, withColor: UIColor(hexString: definition.colorHexString!))

        definitionHeaderView.definitionTextView.editable = false
        enableCustomMenu()

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

    func enableCustomMenu() {
        let lookup = UIMenuItem(title: "Lookup", action: "lookup")
        UIMenuController.sharedMenuController().menuItems = [lookup]
    }

    func disableCustomMenu() {
        UIMenuController.sharedMenuController().menuItems = nil
    }

    func lookup(){
        guard let word = definitionHeaderView.definitionTextView.textInRange(definitionHeaderView.definitionTextView.selectedTextRange!) else {
            return
        }
        searchWord(word)
    }

}

// MARK: Editing and Creating Function
extension WordDefinitionTableViewController : DefinitionDetailDelegate {


    func editDefinition(sender: UIBarButtonItem) {

        navigationItem.setRightBarButtonItems([doneButton, deleteButton, addButton], animated: true)
        definitionHeaderView.definitionTextView.editable = true
        definitionHeaderView.definitionTextView.becomeFirstResponder()
    }

    func doneEdit(sender: UIBarButtonItem) {
        navigationItem.setRightBarButtonItems([editButton, addButton], animated: true)
        definitionHeaderView.definitionTextView.editable = false
    }

    func addDetailButton(sender : UIBarButtonItem) {

        // show action sheet choose key

        // perform showAlertAddDetailForKey
        var actions : [UIAlertAction] = []

        for key in WordsApiDefinitionDetailKey.addableKeys() {

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

    func pressDeleteButton(sender : UIBarButtonItem) {

        let deleteDefinitionAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) -> Void in
            self.deleteDefinition(self.definition!)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler : nil)

        let alertController = UIAlertController(title: "Delete this definition", message: "Are you sure to delete this definition?", preferredStyle: .Alert)
        alertController.addAction(deleteDefinitionAction)
        alertController.addAction(cancelAction)

        presentViewController(alertController, animated: true, completion: nil)

    }

    func pressCardifyButton(sender : UIButton) {

        let needsShow = !(definition?.needsShow)!
        definition?.needsShow = needsShow
        sender.selected = needsShow
        
    }

    func selectDeck(sender: UIButton) {
        print("select Deck")
    }

    func deleteDefinition(definition : MODefinition) {

        managedObjectContext?.deleteObject(definition)
        navigationController?.popViewControllerAnimated(true)

    }

    func searchWordFormDefinition() {
        searchWordFromDetailString(definitionHeaderView.definitionTextView.text!)
    }

    func searchWordFromDetailString(detailString: String) {

        let words = detailString.componentsSeparatedByString(" ")

        let actionSheetController = UIAlertController(title: "Look Up Word", message: "pick the word to search", preferredStyle: .ActionSheet)
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
                let word = MOModelManager.insertWord(wordString, managedObjectContext: managedObjectContext!)

                pushToWord(word)
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