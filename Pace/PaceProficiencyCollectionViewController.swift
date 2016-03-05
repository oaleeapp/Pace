//
//  PaceProficiencyCollectionViewController.swift
//  Pace
//
//  Created by lee on 1/14/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit
import CoreData

protocol PaceProficiencyStatisticsDelegate {
    func levelControllersDidChange(controllers: [PaceLevelResultsController])
}

private let reuseIdentifier = "ProficiencyCell"

class PaceProficiencyCollectionViewController: UICollectionViewController {

    var managedObjectContext : NSManagedObjectContext?
    var statisticsDelegate : PaceProficiencyStatisticsDelegate?
    lazy var levelControllers : [PaceLevelResultsController] = {

        var controllers : [PaceLevelResultsController] = []
        for levelInt in 1...6 {

            let levelController = PaceLevelResultsController(levelInt: levelInt, managedObjectContext: self.managedObjectContext!, levelDelegate: self)
            controllers.append(levelController)

        }

        return controllers

    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "PaceLevelCollectionViewCell", bundle: nil)
        collectionView?.registerNib(nib, forCellWithReuseIdentifier: reuseIdentifier)
        performFetchProficiencyControllers()
        if let delegate = self.statisticsDelegate {
            delegate.levelControllersDidChange(levelControllers)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let flowLayout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        let itemHeight = (collectionView?.bounds.height)! * 3.0 / 5.0
        let itemWidth = itemHeight * 5.0 / 8.0
        flowLayout.itemSize = CGSize(width:itemWidth, height: itemHeight)

        flowLayout.minimumLineSpacing = 64.0
        var insets = collectionView!.contentInset
        let padding = abs((self.view.frame.size.width - flowLayout.itemSize.width) * 0.5)
        insets.left = padding
        insets.right = padding
        collectionView!.contentInset = insets
        collectionView!.decelerationRate = UIScrollViewDecelerationRateFast;
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        cellToCenter()
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PaceLevelCollectionViewCell

        let controller = levelControllers[indexPath.row]
        if let count = controller.sections?.first?.objects?.count {
            cell.levelView.level = controller.level
            cell.countLabel.text = "\(count)"
            cell.levelNameLabel.text = controller.level.name()
            cell.levelNameLabel.textColor = UIColor(themeColor: .LightThemeColor)
            let backgroundColor = count == 0 ? UIColor(themeColor: .LightDescribeColor) : UIColor(themeColor: .LightCardBackgroundColor)
            cell.backView.backgroundColor = backgroundColor
            cell.levelView.view.backgroundColor = backgroundColor
        }

        // Configure the cell

        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let controller = levelControllers[indexPath.row]

        let paceCardVC = storyboard?.instantiateViewControllerWithIdentifier("PaceCardCollectionViewController") as! PaceCardCollectionViewController
        paceCardVC.setUpFetchRequest(controller, managedObjectContext: self.managedObjectContext!)
        navigationController?.pushViewController(paceCardVC, animated: true)
    }

    
    
}

// MARK: Proficiency Delegate
extension PaceProficiencyCollectionViewController : PaceLevelDelegate {

    func levelControllerDidChangeCount(levelController: PaceLevelResultsController, fromCount: Int, toCount: Int) {

        guard let itemIndex = levelControllers.indexOf(levelController) else {

            print("no controller at index")
            return
        }
        let indexPath = NSIndexPath(forItem: itemIndex, inSection: 0)
        collectionView?.reloadItemsAtIndexPaths([indexPath])
        if let delegate = self.statisticsDelegate {
            delegate.levelControllersDidChange(levelControllers)
        }
    }
}
