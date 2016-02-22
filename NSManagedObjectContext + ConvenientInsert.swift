//
//  NSManagedObjectContext + ConvenientInsert.swift
//  Pace
//
//  Created by lee on 12/30/15.
//  Copyright © 2015 OALeeapp. All rights reserved.
//

import Foundation
import CoreData



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
        definition?.needsShow = true
        


    }

    func insertDefinition(definitionStruct: WADefinition) -> MODefinition {

        var details : [MODefinitionDetail] = []
        for key in Array(definitionStruct.details.keys) {
            for text in definitionStruct.details[key]! {
                let newDetail = insertDetail(key, text: text)
                details.append(newDetail)
            }
        }

        let newDefinition = MODefinition(managedObjectContext: self)
        newDefinition.definition = definitionStruct.definition
        newDefinition.partOfSpeech = definitionStruct.partOfSpeech
        newDefinition.details = NSSet(array: details)
        newDefinition.colorHexString = definitionStruct.colorHexString

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