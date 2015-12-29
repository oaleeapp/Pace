//
//  HomeViewController.swift
//  Pace
//
//  Created by lee on 12/21/15.
//  Copyright © 2015 OALeeapp. All rights reserved.
//

import UIKit
import CoreData



class HomeViewController: UIViewController {
    var managedObjectContext: NSManagedObjectContext?

    @IBOutlet weak var newWordTextView: UITextView!

    @IBOutlet weak var SearchResultsContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let searchVC = segue.destinationViewController as? WordSearchViewController
        searchVC?.managedObjectContext = managedObjectContext
        searchVC?.wordTextView = newWordTextView
        newWordTextView.delegate = searchVC
    }



    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func ShowCards(sender: UIButton) {
    }

    @IBAction func TakePace(sender: UIButton) {
    }
}
