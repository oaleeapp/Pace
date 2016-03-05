//
//  PaceMainViewController.swift
//  Pace
//
//  Created by lee on 1/12/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit
import CoreData

class PaceMainViewController: UIViewController , SegueHandlerType{

    enum SegueIdentifier : String {
        case ProficiencySegue = "PaceProficiencySegue"
    }

    var managedObjectContext : NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Pace"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segueIdentifierForSegue(segue){
        case .ProficiencySegue :

            let destVC = segue.destinationViewController as! PaceProficiencyCollectionViewController
            destVC.managedObjectContext = self.managedObjectContext
            destVC.statisticsDelegate = self
        }
    }

}

extension PaceMainViewController : PaceProficiencyStatisticsDelegate {
    func levelControllersDidChange(controllers: [PaceLevelResultsController]) {
        print("level change")
//        let levelCountArray = controllers.map{
//            $0.count
//        }
//        statisticsView.levelCountArray = levelCountArray
    }
}
