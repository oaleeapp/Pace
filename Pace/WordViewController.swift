//
//  WordViewController.swift
//  Pace
//
//  Created by lee on 1/3/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit
import CoreData

class WordViewController: UIViewController, SegueHandlerType {

    var managedObjectContext : NSManagedObjectContext?
    var word : MOWord?

    @IBOutlet weak var wordLabel: UILabel!

    @IBOutlet weak var syllablesLabel: UILabel!

    @IBOutlet weak var pronunciationLabel: UILabel!


    //DefinitionSegue
    enum SegueIdentifier: String {
        case DefinitionSegue = "DefinitionSegue"
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segueIdentifierForSegue(segue){
        case .DefinitionSegue:
            guard let destination = segue.destinationViewController as? WordDefinitionsCollectionViewController
                else { fatalError("segue not possible") }
            destination.setUpManagedObjectContect(self.managedObjectContext, word: word)

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.wordLabel.text = word?.word
        self.syllablesLabel.text = word?.syllables
        self.pronunciationLabel.text = word?.pronunciation
    }
    
}
