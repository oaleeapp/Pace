//
//  PaceCardCollectionViewController.swift
//  Pace
//
//  Created by lee on 1/12/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "PaceCardCell"

class PaceCardCollectionViewController: UICollectionViewController {

    @IBOutlet var levelView: PaceLevelView!

    @IBOutlet var coverView: UIView!

    var managedObjectContext : NSManagedObjectContext?
    var level: WordDefinitionProficiencyLevel = .Never

    var shouldReloadCollectionView = false
    var blockOperation : NSBlockOperation?

    var movingCell = PaceCardView(frame: CGRect.zero)
    var touchOriginPoint : CGPoint = CGPoint.zero
    var touchCell : PaceCardCollectionViewCell?

    lazy var fetchedResultsController : NSFetchedResultsController = {
        let cardFetchRequest = NSFetchRequest(entityName: MODefinition.entityName())
        let primarySortDescriptor = NSSortDescriptor(key: "word.word", ascending: true)
        cardFetchRequest.sortDescriptors = [primarySortDescriptor]

        let proficiency = 0
        let predicate = NSPredicate(format: "needsShow = TRUE && proficiency == %d", proficiency)
        cardFetchRequest.predicate = predicate

        let frc = NSFetchedResultsController(fetchRequest: cardFetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)

        frc.delegate = self

        return frc

    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = level.name()

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: self.view.frame.width - 32.0, height: self.view.frame.height - 232.0)
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumInteritemSpacing = 32.0
        flowLayout.sectionInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        collectionView?.collectionViewLayout = flowLayout

        collectionView?.decelerationRate = 0.0

        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        longPressRecognizer.minimumPressDuration = 0.1
        longPressRecognizer.delegate = self
        collectionView?.addGestureRecognizer(longPressRecognizer)

       

        do {
            try fetchedResultsController.performFetch()
            collectionView?.reloadData()
        } catch {
            print("\(error)")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func setUpFetchRequest(levelController : PaceLevelResultsController, managedObjectContext: NSManagedObjectContext) {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: levelController.fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        level = levelController.level
        do {
            try fetchedResultsController.performFetch()
            collectionView?.reloadData()
        } catch {
            print("\(error)")
        }
    }


    func centeredCell(cell : UICollectionViewCell) {
        let indexPath = collectionView!.indexPathForCell(cell)
        collectionView!.scrollToItemAtIndexPath(indexPath!, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
    }
}

// MARK: UICollectionViewDataSource
extension PaceCardCollectionViewController {

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return numberOfSections()
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return numberOfRowForSection(section)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PaceCardCollectionViewCell

        // Configure the cell
        configureCell(cell, indexPath: indexPath)

        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PaceCardCollectionViewCell
        cell.cardView.flip()
        
    }

    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let cardCell = cell as! PaceCardCollectionViewCell
        cardCell.cardView.setFace(.Front, withAnimated: false)
        
    }


}

// MARK: scroll view delegate
extension PaceCardCollectionViewController {

    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        cellToCenter()

    }

    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        cellToCenter()
    }



}

// MARK: Pan Gesture Handler & delegate
extension PaceCardCollectionViewController : UIGestureRecognizerDelegate{

    enum PanResult {
        case LevelStay
        case LevelUp
        case LevelDown
    }


    func handleLongPress(longPressRecognizer: UILongPressGestureRecognizer){
        let locationPoint = longPressRecognizer.locationInView(self.collectionView)

        switch longPressRecognizer.state{
        case .Began :

            guard let indexPath = collectionView?.indexPathForItemAtPoint(locationPoint) else {
                print("this point has no indexPath")
                break
            }
            touchOriginPoint = locationPoint
            let cell = collectionView?.cellForItemAtIndexPath(indexPath) as! PaceCardCollectionViewCell
            touchCell = cell
            configureMovingCellFromCell(cell)
            cell.hidden = true
            coverView.frame = (collectionView?.bounds)!
            collectionView?.addSubview(coverView)
            collectionView?.addSubview(levelView(levelView, withframe: cell.frame))
            collectionView?.addSubview(movingCell)


        case .Changed :

            guard touchOriginPoint != CGPoint.zero else {
                return
            }

            let deltaY = touchOriginPoint.y - locationPoint.y
            movingCell.center = CGPoint(x: (touchCell?.center.x)!, y: (touchCell?.center.y)! - deltaY)

            let threshold = (touchCell?.bounds.height)!/2
            levelViewMovedY(deltaY, threshold: threshold, withCurrentLevel: (touchCell?.cardView.level)!)


        case .Ended :

            guard touchOriginPoint != CGPoint.zero else {
                return
            }
            guard let indexPath = collectionView?.indexPathForCell(touchCell!) else {
                print("this point has no indexPath")
                break
            }
            let definitionCard = fetchedResultsController.objectAtIndexPath(indexPath) as! MODefinition
            var result : PanResult = .LevelStay
            let deltaY = touchOriginPoint.y - locationPoint.y
            if abs(deltaY) <= (touchCell?.bounds.height)!/2{

                print("no change")

            } else if deltaY > 0 {
                if definitionCard.level != .Master {
                    result = .LevelUp
                }
            } else {
                if definitionCard.level != .Never {
                    result = .LevelDown
                }
            }
            endPanWithResult(result, withDefinitionCard: definitionCard)


        default:
            break

        }
    }

    func endPanWithResult(result: PanResult, withDefinitionCard definitionCard: MODefinition) {

        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.animateWithResult(result)
            }) { (isFinished) -> Void in
                if isFinished {
                    self.touchOriginPoint = CGPoint.zero
                    self.movingCell.removeFromSuperview()
                    self.levelView.removeFromSuperview()
                    self.coverView.removeFromSuperview()
                    self.coverView.alpha = 0.0
                    self.touchCell?.hidden = false
                    self.switchLevelWithResult(result, withDefinitionCard: definitionCard)
                }
        }

    }

    func animateWithResult(result: PanResult) {

        var frame = (touchCell?.frame)!
        switch result {
        case .LevelStay:
            movingCell.frame = frame
        case .LevelUp:
            frame.origin.y = -self.collectionView!.frame.height
            movingCell.frame = frame
        case .LevelDown:
            frame.origin.y = self.collectionView!.frame.height
            movingCell.frame = frame
        }
    }

    func switchLevelWithResult(result: PanResult, withDefinitionCard definitionCard: MODefinition) {
        switch result {
        case .LevelStay:
            print("no change")
        case .LevelUp:
            definitionCard.levelUp()
        case .LevelDown:
            definitionCard.levelDown()
        }
    }

}

// MARK : level view
extension PaceCardCollectionViewController {

    func levelView(levelView: PaceLevelView, withframe frame: CGRect) -> PaceLevelView {
        let sideLength = min(frame.width, frame.height) * 0.6
        levelView.frame = CGRect(x: 0, y: 0, width: sideLength, height: sideLength)
        levelView.center = CGPoint(x: frame.midX, y: frame.midY)
        return levelView
    }

    func levelViewMovedY(movedY: CGFloat, threshold: CGFloat, withCurrentLevel currentLevel: WordDefinitionProficiencyLevel) {



        if movedY >= 0 {
            levelView.level = currentLevel.nextLevel()
            coverView.backgroundColor = UIColor(themeColor: .LightLevelUpColor)
            let alpha = threshold > movedY ? movedY / threshold : 1.0
            levelView.alpha = alpha
            coverView.alpha = alpha / 2.0
            let deltaY = threshold > movedY ? movedY : threshold
            levelView.center = CGPoint(x: (touchCell?.center.x)!, y: (touchCell?.center.y)! + deltaY / 2.0 )


        } else {
            levelView.level = currentLevel.previousLevel()
            coverView.backgroundColor = UIColor(themeColor: .LightLevelDownColor)
            let alpha = threshold > abs(movedY) ? abs(movedY) / threshold : 1.0
            levelView.alpha = alpha
            coverView.alpha = alpha / 2.0
            let deltaY = threshold > abs(movedY) ? movedY : -threshold
            levelView.center = CGPoint(x: (touchCell?.center.x)!, y: (touchCell?.center.y)! + deltaY / 2.0 )
        }
    }

    func configureMovingCellFromCell(cell: PaceCardCollectionViewCell) {
        movingCell.frontView.wordLabel.text = cell.cardView.frontView.wordLabel.text
        movingCell.frontView.syllablesLabel.text = cell.cardView.frontView.syllablesLabel.text
        movingCell.frontView.pronunciationLabel.text = cell.cardView.frontView.pronunciationLabel.text
        movingCell.backView.definitionLabel.text = cell.cardView.backView.definitionLabel.text

        movingCell.level = cell.cardView.level
        movingCell.partOfSpeechColor = cell.cardView.partOfSpeechColor
        self.movingCell.setFace(cell.cardView.face, withAnimated: false)
        movingCell.frame = cell.frame
    }

}


// MARK : Fetched Results Controller Delegate
// FROM : https://gist.github.com/lukasreichart/0ce6b782a5428bd17904

extension PaceCardCollectionViewController : NSFetchedResultsControllerDelegate{


    func numberOfSections() -> Int {
        guard let sectionCount = fetchedResultsController.sections?.count else {
            return 0
        }
        return sectionCount
    }

    func numberOfRowForSection(section : Int) -> Int {
        guard let sectionData = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionData.numberOfObjects
    }

    func configureCell(cell: PaceCardCollectionViewCell, indexPath: NSIndexPath) -> PaceCardCollectionViewCell {

        let definitionCard = fetchedResultsController.objectAtIndexPath(indexPath) as! MODefinition
        cell.cardView.frontView.wordLabel.text = definitionCard.word?.word
        cell.cardView.frontView.syllablesLabel.text = definitionCard.word?.syllables
        cell.cardView.frontView.pronunciationLabel.text = definitionCard.word?.pronunciation
        cell.cardView.backView.definitionLabel.text = definitionCard.definition
        cell.cardView.partOfSpeechColor = UIColor(hexString: definitionCard.colorHexString!)
        cell.cardView.level = definitionCard.level
        return cell
    }


    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.shouldReloadCollectionView = false
        self.blockOperation = NSBlockOperation()
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {

        guard let collectionView = self.collectionView else {
            print("collectionView error")
            return
        }

        guard let blockOperation = self.blockOperation else {
            print("self.blockOperation = nil")
            return
        }
        switch type {
        case NSFetchedResultsChangeType.Insert:
            blockOperation.addExecutionBlock({
                collectionView.insertSections( NSIndexSet(index: sectionIndex) )
            })
        case NSFetchedResultsChangeType.Delete:
            blockOperation.addExecutionBlock({
                collectionView.deleteSections( NSIndexSet(index: sectionIndex) )
            })
        case NSFetchedResultsChangeType.Update:
            blockOperation.addExecutionBlock({
                collectionView.reloadSections( NSIndexSet(index: sectionIndex ) )
            })
        default:()
        }
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        guard let collectionView = self.collectionView else {
            print("collectionView error")
            return
        }

        guard let blockOperation = self.blockOperation else {
            print("self.blockOperation = nil")
            return
        }
        switch type {
        case NSFetchedResultsChangeType.Insert:
            if collectionView.numberOfSections() > 0 {

                if collectionView.numberOfItemsInSection( newIndexPath!.section ) == 0 {
                    self.shouldReloadCollectionView = true
                } else {
                    blockOperation.addExecutionBlock({
                        collectionView.insertItemsAtIndexPaths( [newIndexPath!] )
                    })
                }

            } else {
                self.shouldReloadCollectionView = true
            }

        case NSFetchedResultsChangeType.Delete:
            if collectionView.numberOfItemsInSection( indexPath!.section ) == 1 {
                self.shouldReloadCollectionView = true
            } else {
                blockOperation.addExecutionBlock({
                    collectionView.deleteItemsAtIndexPaths( [indexPath!] )
                })
            }

        case NSFetchedResultsChangeType.Update:
            blockOperation.addExecutionBlock({
                collectionView.reloadItemsAtIndexPaths( [indexPath!] )
            })

        case NSFetchedResultsChangeType.Move:
            blockOperation.addExecutionBlock({
                collectionView.moveItemAtIndexPath( indexPath!, toIndexPath: newIndexPath! )
            })
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        // Checks if we should reload the collection view to fix a bug @ http://openradar.appspot.com/12954582
        guard let collectionView = self.collectionView else {
            print("collectionView error")
            return
        }

        guard let blockOperation = self.blockOperation else {
            print("self.blockOperation = nil")
            return
        }

        if self.shouldReloadCollectionView {
            collectionView.reloadData()
        } else {
            collectionView.performBatchUpdates({
                blockOperation.start()
                }, completion: nil )
        }
    }
    
}

