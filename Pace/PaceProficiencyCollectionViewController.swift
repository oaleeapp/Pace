//
//  PaceProficiencyCollectionViewController.swift
//  Pace
//
//  Created by lee on 1/14/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "ProficiencyCell"

class PaceProficiencyCollectionViewController: UICollectionViewController {

    var managedObjectContext : NSManagedObjectContext?
    lazy var levelControllers : [PaceLevelResultsController] = {

        var controllers : [PaceLevelResultsController] = []
        for levelInt in 0...5 {

            let levelController = PaceLevelResultsController(levelInt: levelInt, managedObjectContext: self.managedObjectContext!, levelDelegate: self)
            controllers.append(levelController)

        }

        return controllers

    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let rect = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: self.view.bounds.height * 2 / 3)
        let padding = CGFloat.init(16.0)
        let itemWidth = (rect.width - 4 * padding) / 3
        let itemHeight = (rect.height - 4 * padding) / 2
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
//        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumInteritemSpacing = padding
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.minimumInteritemSpacing = padding
        flowLayout.minimumLineSpacing = padding 
        collectionView?.collectionViewLayout = flowLayout

        performFetchProficiencyControllers()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func performFetchProficiencyControllers() {

        for controller in levelControllers {

            do {
                try controller.performFetch()
            } catch {
                print("\(levelControllers.indexOf(controller)) controller has error \n \(error)")
            }
        }

    }

}

// MARK: UICollectionViewDataSource
extension PaceProficiencyCollectionViewController {


    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return levelControllers.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PaceProficiencyCollectionViewCell

        let controller = levelControllers[indexPath.row]
        if let count = controller.sections?.first?.objects?.count {
            cell.newLabel.text = "\(count)"
        }

        // Configure the cell

        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let controller = levelControllers[indexPath.row]

        let paceCardVC = storyboard?.instantiateViewControllerWithIdentifier("PaceCardCollectionViewController") as! PaceCardCollectionViewController
        paceCardVC.setUpFetchRequest(controller.fetchRequest, managedObjectContext: self.managedObjectContext!)
        navigationController?.pushViewController(paceCardVC, animated: true)
    }
}

// MARK: Proficiency Delegate
extension PaceProficiencyCollectionViewController : PaceLevelDelegate {

    func levelControllerDidChangeCount(levelController: PaceLevelResultsController, fromCount: Int, toCount: Int) {

        guard let item = levelControllers.indexOf(levelController) else {

            print("no controller at index")
            return
        }
        let indexPath = NSIndexPath(forItem: item, inSection: 0)
        collectionView?.reloadItemsAtIndexPaths([indexPath])
    }
}
