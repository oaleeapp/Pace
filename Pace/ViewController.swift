//
//  ViewController.swift
//  Pace
//
//  Created by lee on 12/17/15.
//  Copyright © 2015 OALeeapp. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

var a = ""

class ViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!


    var managedObjectContext: NSManagedObjectContext? = nil
    var fetchedResultsController : NSFetchedResultsController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initFetchedController()
        try! fetchedResultsController?.performFetch()

        tableView.delegate = self
        tableView.dataSource = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initFetchedController() {

        let fetchRequest = NSFetchRequest(entityName: "Card")
        let wordSort = NSSortDescriptor(key: "word", ascending: true)
        fetchRequest.sortDescriptors = [wordSort]
        guard let moc = managedObjectContext else {
            print("have no managedObjectContext")
            return
        }
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self

    }


    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (fetchedResultsController?.sections?.count)!

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (fetchedResultsController?.sections?.count)! > 0 {
            let sectionInfo : NSFetchedResultsSectionInfo? = fetchedResultsController?.sections?[section]
            return sectionInfo!.numberOfObjects
        } else {
            return 0;
        }

    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "wordCell")
//        cell.backgroundColor = UIColor.blueColor()
//        cell.textLabel?.text = "hello, world!"
//        cell.detailTextLabel?.text = "hi"
        let card = fetchedResultsController?.objectAtIndexPath(indexPath)
        cell.textLabel?.text = card!.valueForKey("word") as? String
        return cell
    }

    @IBOutlet weak var textField: UITextField!

    @IBAction func create(sender: UIButton) {

//        textField.resignFirstResponder()
//        if textField?.text?.characters.count != 0 {
//            print(textField.text)
//            let moc = managedObjectContext!
//            let newWord = NSEntityDescription .insertNewObjectForEntityForName("Card", inManagedObjectContext: moc)
//            newWord.setValue(textField.text, forKey: "word")
//        }
            Alamofire.request(.GET, "https://wordsapiv1.p.mashape.com/words/incredible/definitions", headers: ["X-Mashape-Key": "OOulweLtHDmshn1f5O2lwpfNaRuNp1ctLZLjsnrsNMHWL8E6Pt", "Accept": "application/json"])
            .responseJSON { response in
                    debugPrint(response)
            }

    }

}

