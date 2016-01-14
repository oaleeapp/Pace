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

// MARK: insert Word

extension NSManagedObjectContext {
    enum MOWordError : ErrorType {
        case EmptyDefinitions
    }


    func insertWord(word: WAWord) throws -> MOWord{
        guard let defStructs = word.definitions else {
            // has no definitions

            throw MOWordError.EmptyDefinitions
        }

        var definitions : [MODefinition] = []
        for defStruct in defStructs {
            definitions.append(insertDefinition(defStruct))
        }


        let newWord = MOWord(managedObjectContext: self)
        let newCard = insertCard(newWord)
        newWord.word = word.word
        newWord.syllables = word.syllables.list.joinWithSeparator("-")
        newWord.pronunciation = "/" + (word.pronunciation?.all)! + "/"
        newWord.frequency = word.frequency
        newWord.definitions = NSSet(array: definitions)
        if definitions.count != 0 {
            newCard.definition = definitions.first
        }


        return newWord
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

    func insertCard(word : MOWord) -> MOCard {
        let newCard = MOCard(managedObjectContext: self)
        newCard.word = word
        return newCard
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