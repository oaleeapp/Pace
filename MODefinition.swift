//
//  MODefinition.swift
//  Pace
//
//  Created by lee on 1/8/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import Foundation
import CoreData

enum MOPartOfSpeechType : String{
    case Noun = "noun"
    case Pronoun = "pronoun"
    case Adjective = "adjective"
    case Verb = "verb"
    case Adverb = "adverb"
    case Preposition = "preposition" // have no this type
    case Conjunction = "conjunction"
    case Interjection = "interjection" // have no this type
    case ArticleDefinite = "definite article"
    case ArticleIndefinite = "indefinite article"
    case Undefine = "Undefine"

    static func partOfSpeechList() -> [MOPartOfSpeechType] {
        return [.Noun, .Verb, .Adjective, .Adverb, .Pronoun, .Conjunction, .Interjection, .ArticleDefinite, .ArticleIndefinite]
    }

    func abbreviation() -> String{

        switch self{
        case .Noun:
            return "n."
        case .Pronoun:
            return "pron."
        case .Adjective:
            return "adj."
        case .Verb:
            return "v."
        case .Adverb:
            return "adv."
        case .Preposition:
            return "prep."
        case .Conjunction:
            return "conj."
        case .Interjection:
            return "int."
        case .ArticleDefinite:
            return "def.a."
        case .ArticleIndefinite:
            return "indef.a."
        case .Undefine:
            return "-"
        }

    }

    func colorHexString() -> String {

        switch self{
        case .Noun:
            return "007AFF"
        case .Pronoun:
            return "34AADC"
        case .Adjective:
            return "FF9500"
        case .Verb:
            return "FF3B30"
        case .Adverb:
            return "FFF100"
        case .Preposition:
            return "4CD964"
        case .Conjunction:
            return "5856D6"
        case .Interjection:
            return "FF2D55"
        case .ArticleDefinite:
            return "5A5A5A"
        case .ArticleIndefinite:
            return "5A5A5A"
        case .Undefine:
            return "5A5A5A"
        }
    }
}

enum WordDefinitionProficiencyLevel : Int {
    case Never = 1
    case Heard = 2
    case Recognized = 3
    case Understand = 4
    case Fluent = 5
    case Master = 6

    func description() ->String {

        var descriptionString = String()
        switch self {

        case .Never:
            descriptionString = "Never encountered the word."
        case .Heard:
            descriptionString = "Heard the word, but cannot define it."
        case .Recognized:
            descriptionString = "Recognize the word due to context or tone of voice."
        case .Understand:
            descriptionString = "Able to use the word and understand the general and/or intended meaning, but cannot clearly explain it."
        case .Fluent:
            descriptionString = "Fluent with the word – its use and definition."
        case .Master:
            descriptionString = "Totally Master the meaning."

        }

        return descriptionString
    }

    func name() ->String {

        var name = String()
        switch self {

        case .Never:
            name = "Never"
        case .Heard:
            name = "Heard"
        case .Recognized:
            name = "Recognized"
        case .Understand:
            name = "Understand"
        case .Fluent:
            name = "Fluent"
        case .Master:
            name = "Master"

        }

        return name
    }

    func symbol() ->String {

        var symbolString = String()
        switch self {

        case .Never:
            symbolString = "Ⅰ"
        case .Heard:
            symbolString = "Ⅱ"
        case .Recognized:
            symbolString = "Ⅲ"
        case .Understand:
            symbolString = "Ⅳ"
        case .Fluent:
            symbolString = "Ⅴ"
        case .Master:
            symbolString = "⍟"

        }
        
        return symbolString
    }

    mutating func levelUp(){
        self = self != .Master ? WordDefinitionProficiencyLevel(rawValue: self.rawValue + 1)! : self
    }

    mutating func levelDown() {
        self = self != .Never ? WordDefinitionProficiencyLevel(rawValue: self.rawValue - 1)! : self
    }

    func nextLevel() ->WordDefinitionProficiencyLevel{
        guard self != .Master else {
            return .Master
        }

        return WordDefinitionProficiencyLevel(rawValue: self.rawValue + 1)!

    }

    func previousLevel() ->WordDefinitionProficiencyLevel{
        guard self != .Never else {
            return .Never
        }

        return WordDefinitionProficiencyLevel(rawValue: self.rawValue - 1)!
    }

}


class MODefinition: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override func awakeFromInsert() {
        super.awakeFromInsert()
        addRecordFromLevel(0, toLevel: 0)
    }

    var level: WordDefinitionProficiencyLevel {
        get{
            guard let level = WordDefinitionProficiencyLevel(rawValue: Int(proficiency)) else {
                return .Never
            }
            
            return level
        }
        set{
            let newProficiency = Int16(newValue.rawValue)
            addRecordFromLevel(proficiency, toLevel: newProficiency)
            proficiency = newProficiency
            checkCount += 1
        }
    }

    func levelUp() {

        level.levelUp()

    }

    func levelDown() {
        level.levelDown()
    }

    func addDetail(detail : MODefinitionDetail) {

        self.mutableSetValueForKey("details").addObject(detail)
        
    }

    func addDetails(details : [MODefinitionDetail]) {
        self.mutableSetValueForKey("details").addObjectsFromArray(details)
    }

    func addDeck(deck: MODeck) {

        self.mutableSetValueForKey("decks").addObject(deck)

    }

    func removeDeck(deck: MODeck) {

        self.mutableSetValueForKey("decks").removeObject(deck)
        
    }

    func addRecordFromLevel(fromLevel: Int16, toLevel: Int16) {
        let record = MODefinitionHistory(managedObjectContext: self.managedObjectContext!)
        record.levelChangeAmount = toLevel - fromLevel
        record.updatedAt = NSDate.timeIntervalSinceReferenceDate()
        self.mutableSetValueForKey("records").addObject(record)
    }

}
