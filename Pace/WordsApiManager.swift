//
//  WordsApiManager.swift
//  Pace
//
//  Created by lee on 12/25/15.
//  Copyright © 2015 OALeeapp. All rights reserved.
//

import Foundation
import Alamofire



// should has singleton
struct WordsApi {

    private let wordsApiURL = "https://wordsapiv1.p.mashape.com/words/"
    private let headers = [
        "X-Mashape-Key" : "OOulweLtHDmshn1f5O2lwpfNaRuNp1ctLZLjsnrsNMHWL8E6Pt",
        "Accept" : "application/json"]
    private struct WAKeys {
        static let word = "word"
        static let syllables = "syllables"
        static let syllablesCount = "count"
        static let syllablesList = "list"
        static let Pronunciation = "pronunciation" // can be String or Dcitionary
        static let PronunciationAll = "all"
        static let PronunciationNoun = "noun"
        static let PronunciationVerb = "verb"
        static let frequency = "frequency"
        static let results = "results"
        static let definition = "definition"
        static let partOfSpeech = "partOfSpeech"
        static let derivation = "derivation"
        static let similarTo = "similarTo"
        static let synonyms = "synonyms"
        static let antonyms = "antonyms"
        static let examples = "examples"
        static let attribute = "attribute"
        static let also = "also"
        static let inCategory = "inCategory"
        static let hasTypes = "hasTypes"
        static let typeOf = "typeOf"
    }

    func getWord(word: String, completor: (result: WAWord) -> Void) {

        Alamofire.request(Method.GET, wordsApiURL + word, headers: headers)
            .responseJSON { response in

//                debugPrint(response)
                switch response.result {
                case .Success:

                    print("Validation Successful")

                    let json = JSON(data: response.data!)
                    print(json)
                    if json.count != 0 {
                        let word = self.wordFromJson(json)
                        completor(result: word)
                    } else {
                        print("have no data for \(word)")
                    }
                    
                case .Failure(let error):
                    print(error)
                }



        }

    }

    func wordFromJson(json: JSON) -> WAWord{
        let wordString = json[WAKeys.word].stringValue
        let frequency = json[WAKeys.frequency].doubleValue
        let syllables = syllablesFromJson(json[WAKeys.syllables])
        let pronunciation = pronunciationFromJson(json[WAKeys.Pronunciation])
        let definitions = json[WAKeys.results]
            .map{(_,json) in definitionFromJson(json)}
        var word = WAWord(word: wordString,
            syllables: syllables, frequency: frequency)
        word.pronunciation = pronunciation
        word.definitions = definitions
        return word

    }
    func definitionFromJson(json: JSON) -> WADefinition{
        let definitionString = json[WAKeys.definition].stringValue
        let partOfSpeech = WordsAPIPartOfSpeechType.init(rawValue: json[WAKeys.partOfSpeech].stringValue)

        var definition = WADefinition(definitoin: definitionString,
                                    partOfSpeech: (partOfSpeech?.abbreviation())!,
                                colorHexString: (partOfSpeech?.colorHexString())!)

        definition.details[WAKeys.derivation] = json[WAKeys.derivation].arrayObject as? [String]
        definition.details[WAKeys.similarTo] = json[WAKeys.similarTo].arrayObject as? [String]
        definition.details[WAKeys.synonyms] = json[WAKeys.synonyms].arrayObject as? [String]
        definition.details[WAKeys.antonyms] = json[WAKeys.antonyms].arrayObject as? [String]
        definition.details[WAKeys.examples] = json[WAKeys.examples].arrayObject as? [String]
        definition.details[WAKeys.attribute] = json[WAKeys.attribute].arrayObject as? [String]
        definition.details[WAKeys.also] = json[WAKeys.also].arrayObject as? [String]
        definition.details[WAKeys.inCategory] = json[WAKeys.inCategory].arrayObject as? [String]
        definition.details[WAKeys.hasTypes] = json[WAKeys.hasTypes].arrayObject as? [String]
        definition.details[WAKeys.typeOf] = json[WAKeys.typeOf].arrayObject as? [String]

        return definition
    }
    func syllablesFromJson(json: JSON) -> WASyllables{
        guard let list = json[WAKeys.syllablesList].arrayObject else {
            return WASyllables(count: 0, list: [""])
        }
        return WASyllables(
            count: json[WAKeys.syllablesCount].intValue,
            list: list as! [String])
    }

    func pronunciationFromJson(json: JSON) -> WAPronunciation{
        if let allPronunciation = json.string {
            return WAPronunciation(all: allPronunciation)
        } else {
            let pronunciation = json.dictionaryValue
            guard let all = pronunciation[WAKeys.PronunciationAll]?.stringValue else {
                // TODO : need handle
                return WAPronunciation(all: "no data")
            }
            let noun = pronunciation[WAKeys.PronunciationNoun]?.string
            let verb = pronunciation[WAKeys.PronunciationVerb]?.string
            var wordPronunciation = WAPronunciation(all: all)
            wordPronunciation.noun = noun
            wordPronunciation.verb = verb
            return wordPronunciation

        }
    }

}


struct WAWord {
    var word : String
    var syllables : WASyllables
    var definitions : [WADefinition]?
    var frequency : Double
    var pronunciation : WAPronunciation?

    init(word: String, syllables: WASyllables, frequency: Double) {
        self.word = word
        self.syllables = syllables
        self.frequency = frequency
    }
}

struct WASyllables {
    var count : Int
    var list : [String]

    init(count: Int, list: [String]){
        self.count = count
        self.list = list
    }
}

struct WAPronunciation {
    var all : String
    var noun : String?
    var verb : String?

    init(all: String){
        self.all = all
    }
}

struct WADefinition {
    var definition : String
    var partOfSpeech : String
    var colorHexString : String
    var details : [String : [String]] = [:]

    init(definitoin: String, partOfSpeech: String, colorHexString: String) {
        self.definition = definitoin
        self.partOfSpeech = partOfSpeech
        self.colorHexString = colorHexString
    }
}




enum WordsAPIPartOfSpeechType : String{
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
            return "FFCC00"
        case .Preposition:
            return "4CD964"
        case .Conjunction:
            return "5856D6"
        case .Interjection:
            return "FF2D55"
        case .ArticleDefinite:
            return "4A4A4A"
        case .ArticleIndefinite:
            return "2B2B2B"
        }
    }
}




//For HTTP headers that do not change, it is recommended to set them on the NSURLSessionConfiguration so they are automatically applied to any NSURLSessionTask created by the underlying NSURLSession.
