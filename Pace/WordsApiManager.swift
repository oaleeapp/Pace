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
            debugPrint(response)
                print(response.request?.allHTTPHeaderFields)
                let json = JSON(data: response.data!)
                print(json)
                if json.count != 0 {
                    let word = self.wordFromJson(json)
                    completor(result: word)
                } else {
                    // have no data online
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
        let partOfSpeech = json[WAKeys.partOfSpeech].stringValue
        var definition = WADefinition(definitoin: definitionString, partOfSpeech: partOfSpeech)
        definition.derivation = json[WAKeys.derivation].arrayObject as? [String]
        definition.similatTo = json[WAKeys.similarTo].arrayObject as? [String]
        definition.synonyms = json[WAKeys.synonyms].arrayObject as? [String]
        definition.antonyms = json[WAKeys.antonyms].arrayObject as? [String]
        definition.examples = json[WAKeys.examples].arrayObject as? [String]
        definition.attribute = json[WAKeys.attribute].arrayObject as? [String]
        definition.also = json[WAKeys.also].arrayObject as? [String]
        definition.inCategory = json[WAKeys.inCategory].arrayObject as? [String]
        definition.hasTypes = json[WAKeys.hasTypes].arrayObject as? [String]
        definition.typeOf = json[WAKeys.typeOf].arrayObject as? [String]
        return definition
    }
    func syllablesFromJson(json: JSON) -> WASyllables{
        return WASyllables(
            count: json[WAKeys.syllablesCount].intValue,
            list: json[WAKeys.syllablesList].arrayObject as! [String])
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
    var derivation : [String]?
    var similatTo : [String]?
    var synonyms : [String]?
    var antonyms : [String]?
    var examples : [String]?
    var attribute : [String]?
    var also : [String]?
    var inCategory : [String]?
    var hasTypes : [String]?
    var typeOf : [String]?

    init(definitoin: String, partOfSpeech: String) {
        self.definition = definitoin
        self.partOfSpeech = partOfSpeech
    }
}








//For HTTP headers that do not change, it is recommended to set them on the NSURLSessionConfiguration so they are automatically applied to any NSURLSessionTask created by the underlying NSURLSession.
