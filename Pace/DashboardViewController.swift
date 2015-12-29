//
//  DashboardViewController.swift
//  Pace
//
//  Created by lee on 12/25/15.
//  Copyright © 2015 OALeeapp. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        let wordApiInst = WordsApi()
        wordApiInst.searchWord("wind")
        

        
        
    }

}
