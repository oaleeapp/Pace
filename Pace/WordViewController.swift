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
    var definitionTextField: UITextField?
    var partOfSpeechTextField: UITextField?
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
        navigationItem.title = word?.word
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
            self.definitionTextField = textField
            textField.delegate = self //REQUIRED
            textField.placeholder = "definition"
            textField.addTarget(self, action: "textFieldDidChangeText:", forControlEvents: .EditingChanged)
        }

        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            self.partOfSpeechTextField = textField
            let pickerView = UIPickerView()
            pickerView.delegate = self
            pickerView.dataSource = self
            textField.inputView = pickerView
            textField.placeholder = "part of speech"
        }

        addAction = UIAlertAction(title: "Add", style: .Default, handler: { (alertAction) -> Void in
            let text = alertController.textFields?.first?.text

            let newDefinition = MODefinition(managedObjectContext: self.managedObjectContext!)
            newDefinition.word = self.word
            newDefinition.definition = text
            let partOfSpeech = MOPartOfSpeechType(rawValue: self.partOfSpeechTextField!.text!)
            newDefinition.partOfSpeech = partOfSpeech?.abbreviation()
            newDefinition.colorHexString = partOfSpeech?.colorHexString()
        })
        addAction?.enabled = false
        alertController.addAction(addAction!)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)

    }

    func showFrequencyRankSelectSheet(){

        let alertController = UIAlertController(title: "Usage-Frequency of [\(word!.word!)]", message: nil, preferredStyle: .ActionSheet)
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
        let canAdd = !((definitionTextField?.text?.isEmpty)! || (partOfSpeechTextField?.text!.isEmpty)!)

        addAction?.enabled = canAdd

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

extension WordViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return MOPartOfSpeechType.partOfSpeechList().count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return MOPartOfSpeechType.partOfSpeechList()[row].rawValue
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        partOfSpeechTextField!.text = MOPartOfSpeechType.partOfSpeechList()[row].rawValue
        textFieldDidChangeText(partOfSpeechTextField!)
    }
}