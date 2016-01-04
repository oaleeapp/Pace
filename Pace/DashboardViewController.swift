//
//  DashboardViewController.swift
//  Pace
//
//  Created by lee on 12/25/15.
//  Copyright © 2015 OALeeapp. All rights reserved.
//

import UIKit
import CoreData



class DashboardViewController: UIViewController, SegueHandlerType {

    enum SegueIdentifier: String {
        case wordSearchSegue = "WordSearchSegue"
    }

    var managedObjectContext : NSManagedObjectContext?
    var wordListVC : WordListViewController?

    @IBOutlet weak var wordTextField: UITextField!

    @IBOutlet weak var wordListContainView: UIView!

    @IBOutlet weak var wordListContainViewBottomConstraint: NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()
//        let wordApiInst = WordsApi()
//        wordApiInst.getWord("wild"){wordResult in
//            do{
//                let newWord = try self.insertWord(wordResult)
//                print(newWord)
//            } catch {
//
//            }
//        }
//        wordApiInst.getWord("wing"){wordResult in
//            do{
//                let newWord = try self.insertWord(wordResult)
//                print(newWord)
//            } catch {
//
//            }
//        }
//        wordApiInst.getWord("wiggle"){wordResult in
//            do{
//                let newWord = try self.insertWord(wordResult)
//                print(newWord)
//            } catch {
//
//            }
//        }

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segueIdentifierForSegue(segue){
        case .wordSearchSegue:
            guard let destination = segue.destinationViewController as? WordListViewController
                else { fatalError("segue not possible") }
            destination.managedObjectContext = self.managedObjectContext
            self.wordListVC = destination
        }
    }

}

//MARK: - textField delegate
extension DashboardViewController : UITextFieldDelegate {

    func textFieldDidBeginEditing(textField: UITextField) {
        self.wordListContainView.hidden = false
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.wordListContainView.hidden = true
        return true
    }

    @IBAction func textFieldDidChange(textField: UITextField){
        print("\(textField.text)")
        guard let wordString = textField.text else {
            print("textField has no String")
            return
        }
        self.wordListVC?.searchWord(wordString)

    }
}


//MARK: - Core Data
extension DashboardViewController {

    enum CoreDataError : ErrorType {
        case EmptyDefinitions
    }


    func insertWord(word: WAWord) throws -> Word{
        guard let defStructs = word.definitions else {
            // has no definitions

            throw CoreDataError.EmptyDefinitions
        }

        var definitions : [Definition] = []
        for defStruct in defStructs {
            definitions.append(insertDefinition(defStruct))
        }


        let newWord = Word(managedObjectContext: self.managedObjectContext!)

        newWord.word = word.word
        newWord.definitions = NSSet(array: definitions)

        return newWord
    }

    func insertDefinition(definition: WADefinition) -> Definition {
        let newDefinition = Definition(managedObjectContext: self.managedObjectContext!)
        newDefinition.definitoin = definition.definition
        newDefinition.partOfSpeech = definition.partOfSpeech
        return newDefinition
    }
}

