//
//  WordViewController.swift
//  Pace
//
//  Created by lee on 1/3/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit
import CoreData

class WordViewController: UIViewController, SegueHandlerType {

    var managedObjectContext: NSManagedObjectContext!
    var word: MOWord?
    var addAction: UIAlertAction?
    @IBOutlet weak var wordDetailView: WordDetailView!


    //DefinitionSegue
    enum SegueIdentifier: String {
        case DefinitionSegue = "DefinitionSegue"
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segueIdentifierForSegue(segue){
        case .DefinitionSegue:
            guard let destination = segue.destinationViewController as? WordDefinitionsCollectionViewController
                else { fatalError("segue not possible") }
            destination.setUpManagedObjectContect(self.managedObjectContext, word: word)
            destination.definitionDetailDelegate = self

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewDefinitoin:")

        navigationItem.rightBarButtonItems = [addButton]
        setUpWordView()
    }

    func setUpWordView() {
        guard let word = self.word else {
            print("word did setted is invalid")
            return
        }
        let viewModel = WordDetailViewModel(managedObjectContext: self.managedObjectContext, word: word)
        self.wordDetailView.viewModel = viewModel
        self.wordDetailView.setUpWithWord(viewModel.word)
        self.wordDetailView.downloadButton.addTarget(self, action: "showFrequencyRankSelectSheet", forControlEvents: .TouchUpInside)
    }

}


// MARK : - Actions

extension WordViewController {

    func addNewDefinitoin(sender: UIBarButtonItem) {

        print("add new definition")

        let alertController = UIAlertController(title: "New Definition", message: nil, preferredStyle: .Alert)

        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.delegate = self //REQUIRED
            textField.placeholder = "Enter a title for Deck"
//            textField.addTarget(self, action: "textFieldDidChangeText:", forControlEvents: .EditingChanged)
        }

        addAction = UIAlertAction(title: "Add", style: .Default, handler: { (alertAction) -> Void in
            let text = alertController.textFields?.first?.text

            let newDefinition = MODefinition(managedObjectContext: self.managedObjectContext!)
            newDefinition.word = self.word
            newDefinition.definition = text
            newDefinition.partOfSpeech = "noun"

        })
//        addAction?.enabled = false
        alertController.addAction(addAction!)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)

    }

    func showFrequencyRankSelectSheet(){

        let alertController = UIAlertController(title: "Usage-Frequency of [\(word!.word!)]", message: "You can only set once.", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        for rank in FrequencyRank.rankList() {
            let rankAction = UIAlertAction(title: rank.name(), style: .Default){ _ in
                self.word!.rank = rank
            }
            alertController.addAction(rankAction)
        }

        presentViewController(alertController, animated: true, completion: nil)
    }

}

extension WordViewController : UITextFieldDelegate {

    func textFieldDidChangeText(sender : UITextField) {

    }


}

extension WordViewController : WordDefinitionDetailDelegate{

    func showDefinition(definition: MODefinition) {

        let definitionVC = storyboard?.instantiateViewControllerWithIdentifier("WordDefinitionTableViewController") as! WordDefinitionTableViewController
        definitionVC.managedObjectContext = self.managedObjectContext
        definitionVC.definition = definition

        navigationController?.pushViewController(definitionVC, animated: true)
    }
}