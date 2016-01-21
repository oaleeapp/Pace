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

    var managedObjectContext : NSManagedObjectContext?
    var word : MOWord?
    var addAction : UIAlertAction?

    @IBOutlet weak var wordLabel: UILabel!

    @IBOutlet weak var syllablesLabel: UILabel!

    @IBOutlet weak var pronunciationLabel: UILabel!


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

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.wordLabel.text = word?.word
        self.syllablesLabel.text = word?.syllables
        self.pronunciationLabel.text = word?.pronunciation

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewDefinitoin:")

        navigationItem.rightBarButtonItems = [addButton]

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
            newDefinition.definitoin = text

        })
//        addAction?.enabled = false
        alertController.addAction(addAction!)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)



    }

}

extension WordViewController : UITextFieldDelegate {



}