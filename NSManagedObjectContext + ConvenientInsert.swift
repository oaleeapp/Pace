//
//  NSManagedObjectContext + ConvenientInsert.swift
//  Pace
//
//  Created by lee on 12/30/15.
//  Copyright © 2015 OALeeapp. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {

    public func insertObject<T: NSManagedObject>() -> T {
        guard let object = NSEntityDescription.insertNewObjectForEntityForName(T.entityName(), inManagedObjectContext: self) as? T
            else { fatalError("Invalid Core Data Model.") }
        return object;
    }
}

// MARK: insert Word from WordsAPI

extension NSManagedObjectContext {
    enum MOWordError : ErrorType {
        case EmptyDefinitions
    }


    func insertWordForString(string: String) -> MOWord {
        let newWord = MOWord(managedObjectContext: self)

        newWord.word = string

        return newWord
    }

    func modifyWord(word: MOWord, withWordStruct wordStruct: WAWord) {

        guard word.word?.lowercaseString == wordStruct.word.lowercaseString else {
            // wrong word
            print("wrong word")
            return
        }

        guard let definitionStructs = wordStruct.definitions else {
            // has no definitions
            print("has no definitions")
            return
        }

        var definitions : [MODefinition] = []
        for definitionStruct in definitionStructs {
            definitions.append(insertDefinition(definitionStruct))
        }

        word.syllables = wordStruct.syllables.list.joinWithSeparator("-")
        word.pronunciation = "/" + (wordStruct.pronunciation?.all)! + "/"
        word.frequency = wordStruct.frequency
        word.addDefinitions(definitions)


        let definition = definitions.first
        definition?.addCard(MOCard(managedObjectContext: self))

    }

    func insertDefinition(definition: WADefinition) -> MODefinition {

        var details : [MODefinitionDetail] = []
        for key in Array(definition.details.keys) {
            for text in definition.details[key]! {
                let newDetail = insertDetail(key, text: text)
                details.append(newDetail)
            }
        }

        let newDefinition = MODefinition(managedObjectContext: self)
        newDefinition.definitoin = definition.definition
        newDefinition.partOfSpeech = definition.partOfSpeech
        newDefinition.details = NSSet(array: details)

        return newDefinition
    }

    func insertDetail(key: String, text: String) -> MODefinitionDetail{

        let newDetail = MODefinitionDetail(managedObjectContext: self)
        newDetail.key = key
        newDetail.text = text
        return newDetail
    }

}

// MARK: insert Deck
extension NSManagedObjectContext {

    enum MODeckError : ErrorType {
        case Empty
    }

    func insertDeck(title: String) -> MODeck {

        let newDeck = MODeck(managedObjectContext: self)
        newDeck.title = title

        return newDeck
    }
}










extension NSSortDescriptor {

    enum SortWordIdentifier : String {
        case Word = "word"
    }

    convenience init(sortWordIdentifier: SortWordIdentifier, ascending : Bool) {
        self.init(key: sortWordIdentifier.rawValue, ascending: ascending)
    }
}

extension NSPredicate {
    enum PredicateIdentifier : String {
        case IsContainString = "word CONTAINS[cd] %@"
        case IsLikeString = "word.word LIKE[cd] %@"
    }

    convenience init(predicateIdentifier : PredicateIdentifier, _ string: String) {
        self.init(format: predicateIdentifier.rawValue, string)
    }
}