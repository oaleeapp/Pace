//
//  MOModelManager.swift
//  Pace
//
//  Created by lee on 2/17/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import Foundation
import CoreData

class MOModelManager {

    static func insertWord(wordString: String, managedObjectContext: NSManagedObjectContext) ->MOWord{

        let wordLowercaseString = wordString.lowercaseString
        let word = MOWord(managedObjectContext: managedObjectContext)
        word.word = wordLowercaseString
        downloadWord(word)

        return word
    }

    static func downloadWord(word: MOWord){
        word.downloadState = .Downloading
        WordsAPIService.sharedInstance.getWord(word.word!, completor: { (result) -> Void in

            //TODO: handle the download state change
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                word.downloadState = .HasDownloaded
                modifyWord(word, byJsonData: result)
            })

            }, errorHandler: { (error) -> Void in

                //TODO: handle the download state change
                switch error{
                case .NoNetworking:
                    word.downloadState = .NeedsDownload
                case .NoData:
                    word.downloadState = .HasDownloaded
                    word.frequency = 0.0
                case .Unknown:
                    print("Unknown error")
                }
        })
    }

    static func validateWordString(wordString: String) ->Bool {

        let regex = try! NSRegularExpression(pattern: "^[a-z]{0,}$", options: .CaseInsensitive)
        let range = NSMakeRange(0, wordString.characters.count)
        let matchRange = regex.rangeOfFirstMatchInString(wordString, options: .ReportProgress, range: range)
        return  matchRange.location != NSNotFound

    }



}

//MARK: - private MOModelManager
extension MOModelManager {

    private static func modifyWord(word: MOWord, byJsonData json: JSON) {

        word.frequency = json.word(.Frequency).doubleValue
        word.syllables = syllablesFromJson(json.word(.Syllables))
        word.pronunciation = pronunciationFromJson(json.word(.Pronunciation))
        let definitions = json.word(.Results).map{
            (_,definitionJson) in definitionFromJson(definitionJson, toWord: word)
        }
        word.addDefinitions(definitions)
    }

    private static func syllablesFromJson(json: JSON) ->String {
        guard let list = json.word(.SyllablesList).arrayObject else {
            print("no syllables data")
            return "-"
        }
        return (list as! [String]).joinWithSeparator("-")
    }

    private static func pronunciationFromJson(json: JSON) ->String {


        guard let pronunciationDict = json.dictionary else {
            switch json.string {
            case .None:
                return "-"
            case .Some(let pronunciationString):
                return "/\(pronunciationString)/"
            }
        }

        guard let allPronunciationString = pronunciationDict["all"]?.string else {
            print("have no pronunciation all data")
            return "-"
        }

        guard pronunciationDict.count == 1 else {
            let differentPartOfSpeechPronunciationString = pronunciationDict.reduce(""){$1.0 == WordsApiKey.PronunciationAll.rawValue ?
                $0 :
                $0 + "\($1.0.characters.first!). = /\($1.1.stringValue)/ "}
            return differentPartOfSpeechPronunciationString
        }

        return "/\(allPronunciationString)/"

    }

    private static func definitionFromJson(json: JSON, toWord word: MOWord) ->MODefinition {

        let definition = MODefinition(managedObjectContext: word.managedObjectContext!)
        definition.definition = json.word(.Definition).stringValue
        if let partOfSpeech = MOPartOfSpeechType(rawValue: json.word(.PartOfSpeech).stringValue) {
            definition.partOfSpeech = partOfSpeech.abbreviation()
            definition.colorHexString = partOfSpeech.colorHexString()
        } else {
            let undefine = MOPartOfSpeechType.Undefine
            definition.partOfSpeech = undefine.abbreviation()
            definition.colorHexString = undefine.colorHexString()
        }

        let details = json.detailJsons(
            [.Derivation, .SimilarTo, .Synonyms,
                .Antonyms, .Examples, .Attribute,
                .Also, .InCategory, .HasTypes, .TypeOf])
            .map{detailsFromJson($0.1, toKey: $0.0, toDefinition: definition)}
            .flatMap{$0}
        definition.addDetails(details)

        return definition
    }

    private static func detailsFromJson(json: JSON, toKey key: String, toDefinition definition: MODefinition) -> [MODefinitionDetail] {

        let details = json.arrayValue
            .map{$0.stringValue}
            .map{detailFromText($0, andKey: key, toDefinition: definition)}

        return details
    }

    private static func detailFromText(text: String, andKey key: String, toDefinition definition: MODefinition) -> MODefinitionDetail {

        let detail = MODefinitionDetail(managedObjectContext: definition.managedObjectContext!)
        detail.text = text
        detail.key = key

        return detail
    }


    

}


//MARK: - NSManagedObject + EntityName

extension NSManagedObject {

    public class func entityName() -> String {
        // NSStringFromClass is available in Swift 2.
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }

    convenience init(managedObjectContext: NSManagedObjectContext) {
        let entityName = self.dynamicType.entityName()
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedObjectContext)!
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }
}

//MARK: - NSManagedObjectContext + ConvenientInsert

extension NSManagedObjectContext {

    public func insertObject<T: NSManagedObject>() -> T {
        guard let object = NSEntityDescription.insertNewObjectForEntityForName(T.entityName(), inManagedObjectContext: self) as? T
            else { fatalError("Invalid Core Data Model.") }
        return object;
    }
}





