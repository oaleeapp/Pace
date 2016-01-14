//
//  PaceTabBarViewController.swift
//  Pace
//
//  Created by lee on 1/4/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit
import CoreData

class PaceTabBarViewController: UITabBarController, SegueHandlerType {

    enum SegueIdentifier: String {
        case wordSearchSegue = "WordSearchSegue"
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
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }


}
