//
//  CardDetailViewController.swift
//  Pace
//
//  Created by lee on 12/22/15.
//  Copyright © 2015 OALeeapp. All rights reserved.
//

import UIKit
import CoreData
import Alamofire


class CardDetailViewController: UIViewController {
    @IBOutlet weak var wordLabel: UILabel!

    var managedObjectContext: NSManagedObjectContext?

    @IBAction func fetchDictionary(sender: AnyObject) {
    }

    func tryAlamofire() {
        Alamofire.request(.GET, "https://wordsapiv1.p.mashape.com/words/incredible/definitions", headers: ["X-Mashape-Key": "OOulweLtHDmshn1f5O2lwpfNaRuNp1ctLZLjsnrsNMHWL8E6Pt", "Accept": "application/json"])
            .responseData { response in
                print(response.request)
                print(response.response)
                print(response.result)
                guard let dataResult = response.data else {
                    return
                }
                do {
                    let anyObj = try NSJSONSerialization.JSONObjectWithData(dataResult, options: []) as! [String:AnyObject]
                    // use anyObj here
                    print(anyObj)
                } catch {
                    print("json error: \(error)")
                }


        }
    }

}

func test(compeleteFunc: ()){
    compeleteFunc
}
