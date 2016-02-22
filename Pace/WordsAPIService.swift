//
//  WordsAPIService.swift
//  Pace
//
//  Created by lee on 2/17/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import Foundation
import Alamofire

let WordsApiMashapeKey = "OOulweLtHDmshn1f5O2lwpfNaRuNp1ctLZLjsnrsNMHWL8E6Pt"
let WordsApiURL = "https://wordsapiv1.p.mashape.com"

enum WordsApiKey: String {
    case Word = "word"
    case Syllables = "syllables"
    case SyllablesCount = "count"
    case SyllablesList = "list"
    case Pronunciation = "pronunciation" // can be String or Dcitionary
    case PronunciationAll = "all"
    case PronunciationNoun = "noun"
    case PronunciationVerb = "verb"
    case Frequency = "frequency"
    case Results = "results"
    case Definition = "definition"
    case PartOfSpeech = "partOfSpeech"
}

enum WordsApiDefinitionDetailKey : String{

    case Attribute = "attribute"
    case Derivation = "derivation"
    case Examples = "examples"
    case Synonyms = "synonyms"
    case Antonyms = "antonyms"
    case TypeOf = "typeOf"
    case HasTypes = "hasTypes"
    case PartOf = "partOf"
    case HasParts = "hasParts"
    case InstanceOf = "instanceOf"
    case HasInstances = "hasInstances"
    case SimilarTo = "similarTo"
    case Also = "also"
    case Entails = "entails"
    case MemberOf = "memberOf"
    case HasMembers = "hasMembers"
    case SubstanceOf = "substanceOf"
    case HasSubstances = "hasSubstances"
    case InCategory = "inCategory"
    case HasCategories = "hasCategories"
    case UsageOf = "usageOf"
    case HasUsages = "hasUsages"
    case InRegion = "inRegion"
    case RegionOf = "regionOf"
    case PertainsTo = "pertainsTo"

    static func addableKeys() -> [String] {

        let keys = [WordsApiDefinitionDetailKey.Examples.rawValue,
            WordsApiDefinitionDetailKey.Synonyms.rawValue,
            WordsApiDefinitionDetailKey.Antonyms.rawValue,
            WordsApiDefinitionDetailKey.SimilarTo.rawValue]
        return keys
    }
}



extension JSON {

    func word(key: WordsApiKey) ->JSON {
        return self[key.rawValue]
    }

    func detailJsons(keys: [WordsApiDefinitionDetailKey]) ->[(key: String, details: JSON)] {
        return keys.map{($0.rawValue, self[$0.rawValue])}
    }
}

final class WordsAPIService {

    enum WordsApiDownloadError: Int {
        case NoNetworking = -1009
        case NoData = 3840
        case Unknown = 0

        static func errorFromCode(errorCode: Int) ->WordsApiDownloadError {
            guard let error = WordsApiDownloadError(rawValue: errorCode) else {
                return .Unknown
            }

            return error
        }
    }

    static let sharedInstance = WordsAPIService()

    lazy var manager: Manager = {

        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let headers = [
            "X-Mashape-Key" : WordsApiMashapeKey,
            "Accept" : "application/json"]
        configuration.HTTPAdditionalHeaders = headers
        configuration.timeoutIntervalForRequest = 30.0
        let manager = Alamofire.Manager(configuration: configuration)
        manager.startRequestsImmediately = true


        return manager
    }()

    private init() {

    }

    func getWord(word: String, completor: (result: JSON) ->  Void, errorHandler: (error: WordsApiDownloadError) ->  Void){

        let URLString = URLForWord(word)
        manager.request(.GET, URLString).responseJSON { response in

//            debugPrint(response)
            switch response.result {
            case .Success:

                print("Validation Successful")
                let json = JSON(data: response.data!)
//                print(json)
                completor(result: json)

            case .Failure(let error):
                print(error)
                errorHandler(error: WordsApiDownloadError.errorFromCode(error.code))

            }
        }
    }


    func URLForWord(word: String) -> String {
        return WordsApiURL + "/words/\(word)/"
    }

}





