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
        case CardsSegue = "PaceCardsSegue"
    }

    var managedObjectContext : NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segueIdentifierForSegue(segue){
        case .CardsSegue :

            let destVC = segue.destinationViewController as! PaceCardCollectionViewController
            destVC.managedObjectContext = self.managedObjectContext

            break
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
