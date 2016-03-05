//
//  MOWord.swift
//  Pace
//
//  Created by lee on 1/8/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import Foundation
import CoreData



enum WordSearchScopeSortType : String {
    case Latest = "Latest"
    case Alphabet = "Alphabet"
    case Frequency = "Frequency"



    static func scopeList() ->[String] {
        return [self.Latest.rawValue, self.Alphabet.rawValue, self.Frequency.rawValue]
    }

    static func sortDescriptorsForType(sortType: WordSearchScopeSortType) ->[NSSortDescriptor] {

        var sortDescriptors : [NSSortDescriptor] = Array()
        switch sortType{
        case .Latest:
            sortDescriptors = [sortDescriptor(sortType)]
        case .Alphabet:
            sortDescriptors = [sortDescriptor(sortType)]
        case .Frequency:
            sortDescriptors = [sortDescriptor(sortType), sortDescriptor(.Alphabet)]
        }

        return sortDescriptors
    }

    static func sortDescriptor(sortType: WordSearchScopeSortType) ->NSSortDescriptor {
        var sortString = String()
        switch sortType {
        case .Latest:
            sortString = "createdAt"
        case .Alphabet:
            sortString = "word"
        case .Frequency:
            sortString = "frequency"
        }

        return NSSortDescriptor(key: sortString, ascending: ascending(sortType))
    }

    static func ascending(sortType: WordSearchScopeSortType) ->Bool {

        var ascending = Bool()
        switch sortType {
        case .Latest:
            ascending = false
        case .Alphabet:
            ascending = true
        case .Frequency:
            ascending = false
        }

        return ascending
    }

}

enum FrequencyRank: Int {
    case Rarely = 1
    case Occasionally = 2
    case Often = 3
    case Usually = 4
    case Always = 5
    case Undefine = 0

    static var lineCount: Int { return FrequencyRank.Always.hashValue + 1}

    static func rankForFrequency(frequency: Double) ->FrequencyRank {

        var rank = FrequencyRank.Undefine

        switch frequency {

        case FrequencyRank.Rarely.range():
            rank = .Rarely
        case FrequencyRank.Occasionally.range():
            rank = .Occasionally
        case FrequencyRank.Often.range():
            rank = .Often
        case FrequencyRank.Usually.range():
            rank = .Usually
        case FrequencyRank.Always.range():
            rank = .Always
        default:
            rank = .Undefine
        }

        return rank

    }

    static func rankList() ->Array<FrequencyRank> {
        return [.Rarely, .Occasionally, .Often, .Usually, .Always]
    }

    func lengthForMaxLength(maxLength: Double) ->Double{
        var length: Double = 0.0

        if self != .Undefine {
            length = maxLength / Double(FrequencyRank.lineCount + 1 - self.rawValue)
        }

        return length
    }

    func range() -> ClosedInterval<Double> {
        switch self {
        case .Rarely:
            return 0.001...2.999
        case .Occasionally:
            return 3.0...3.999
        case .Often:
            return 4.0...5.499
        case .Usually:
            return 5.5...6.999
        case .Always:
            return 7.0...8.0
        case .Undefine:
            return 0.0...0.0
        }
    }

    func middleValue() ->Double {
        return (self.range().start + self.range().end) / 2.0
    }

    func name() ->String {
        switch self {
        case .Rarely:
            return "Rarely"
        case .Occasionally:
            return "Occasionally"
        case .Often:
            return "Often"
        case .Usually:
            return "Usually"
        case .Always:
            return "Always"
        case .Undefine:
            return "Undefine"
        }
    }

}

enum WordDownloadState : Int {
    case NeedsDownload = 0
    case Downloading = 1
    case HasDownloaded = 2
}



class MOWord: NSManagedObject {



    var downloadState: WordDownloadState {
        get{
            return WordDownloadState.init(rawValue: Int(self.downloadStateRawValue))!
        }
        set{
            self.downloadStateRawValue = Int16(newValue.rawValue)
        }
    }

    var rank : FrequencyRank {
        get{
            return FrequencyRank.rankForFrequency(self.frequency)
        }
        set{
            self.frequency = newValue.middleValue()
        }
    }

    override func awakeFromInsert() {
        super.awakeFromInsert()
        self.createdAt = NSDate.timeIntervalSinceReferenceDate()
    }

    func addDefinition(definition: MODefinition) {

        self.mutableSetValueForKey("definitionList").addObject(definition)

    }

    func removeDefinition(definition: MODefinition) {

        self.mutableSetValueForKey("definitionList").removeObject(definition)

    }

    // multiple
    func addDefinitions(definitions: [MODefinition]) {

        self.mutableSetValueForKey("definitionList").addObjectsFromArray(definitions)
        
    }

    func removeDefinitions(definitions: [MODefinition]) {
        for definition in definitions {
            if self.mutableSetValueForKey("definitionList").containsObject(definition) {
                self.mutableSetValueForKey("definitionList").removeObject(definition)
            }
        }

    }

}

