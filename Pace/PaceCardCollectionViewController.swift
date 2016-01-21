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


    @IBOutlet var gotView: UIView!
    @IBOutlet var studyView: UIView!


    var managedObjectContext : NSManagedObjectContext?
    var proficiencyFetchRequest : NSFetchRequest?

    var shouldReloadCollectionView = false
    var blockOperation : NSBlockOperation?

    var movingCell : UIImageView?
    var touchOriginPoint : CGPoint?
    var touchCell : UICollectionViewCell?

    lazy var fetchedResultsController : NSFetchedResultsController = {
        let cardFetchRequest = NSFetchRequest(entityName: MOCard.entityName())
        let primarySortDescriptor = NSSortDescriptor(key: "definition.word.word", ascending: true)
        cardFetchRequest.sortDescriptors = [primarySortDescriptor]

        let proficiency = 0
        let predicate = NSPredicate(format: "proficiency == %d", proficiency)
        cardFetchRequest.predicate = predicate

        let frc = NSFetchedResultsController(fetchRequest: cardFetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)

        frc.delegate = self

        return frc

    }()

    override func viewDidLoad() {
        super.viewDidLoad()

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


    func setUpFetchRequest(fetchRequest : NSFetchRequest, managedObjectContext: NSManagedObjectContext) {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self

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


        //        let card = fetchedResultsController.objectAtIndexPath(indexPath) as! MOCard
        //        card.proficiency = 1

        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PaceCardCollectionViewCell
        cell.cardView.flip()
        
    }

    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let cardCell = cell as! PaceCardCollectionViewCell
        cardCell.cardView.face = .Front
        
    }

}

// MARK: scroll view delegate
extension PaceCardCollectionViewController {

    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        var closestCell : UICollectionViewCell = collectionView!.visibleCells()[0];
        for cell in collectionView!.visibleCells() as [UICollectionViewCell] {
            let closestCellDelta = abs(closestCell.center.x - collectionView!.bounds.size.width/2.0 - collectionView!.contentOffset.x)
            let cellDelta = abs(cell.center.x - collectionView!.bounds.size.width/2.0 - collectionView!.contentOffset.x)
            if (cellDelta < closestCellDelta){
                closestCell = cell
            }
        }
        let indexPath = collectionView!.indexPathForCell(closestCell)
        collectionView!.scrollToItemAtIndexPath(indexPath!, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)

    }

    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var closestCell : UICollectionViewCell = collectionView!.visibleCells()[0];
        for cell in collectionView!.visibleCells() as [UICollectionViewCell] {
            let closestCellDelta = abs(closestCell.center.x - collectionView!.bounds.size.width/2.0 - collectionView!.contentOffset.x)
            let cellDelta = abs(cell.center.x - collectionView!.bounds.size.width/2.0 - collectionView!.contentOffset.x)
            if (cellDelta < closestCellDelta){
                closestCell = cell
            }
        }
        let indexPath = collectionView!.indexPathForCell(closestCell)
        collectionView!.scrollToItemAtIndexPath(indexPath!, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
    }



}

// MARK: Pan Gesture Handler & delegate
extension PaceCardCollectionViewController : UIGestureRecognizerDelegate{

    func handleLongPress(longPressRecognizer: UILongPressGestureRecognizer){
        let locationPoint = longPressRecognizer.locationInView(self.collectionView)

        switch longPressRecognizer.state{
        case .Began :
            print("began")
            touchOriginPoint = locationPoint
            guard let indexPath = collectionView?.indexPathForItemAtPoint(locationPoint) else {
                print("this point has no indexPath")
                break
            }
            let cell = collectionView?.cellForItemAtIndexPath(indexPath)
            touchCell = cell
            guard let size = cell?.bounds.size else {
                print("cell has no size")
                break
            }
            UIGraphicsBeginImageContext(size)
            guard let ctx = UIGraphicsGetCurrentContext() else {
                print("has no current context")
                break
            }
            cell?.layer.renderInContext(ctx)
            let cellImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            cell?.hidden = true

            movingCell = UIImageView(image: cellImage)
            movingCell?.center = (cell?.center)!
            collectionView?.addSubview(movingCell!)

            addGotAndStudyViewAtFrame((cell?.frame)!, belowView: movingCell!)

        case .Changed :
            print("changed")
            let deltaY = (touchOriginPoint?.y)! - locationPoint.y
            movingCell?.center = CGPoint(x: (touchCell?.center.x)!, y: (touchCell?.center.y)! - deltaY)

            let threshold = (touchCell?.bounds.height)!/2
            gotAndStudyViewMovedY(deltaY, threshold: threshold)



        case .Ended :
            print("ended")

            guard let indexPath = collectionView?.indexPathForCell(touchCell!) else {
                print("this point has no indexPath")
                break
            }
            let card = fetchedResultsController.objectAtIndexPath(indexPath) as! MOCard

            defer {
                movingCell?.removeFromSuperview()
                touchCell?.hidden = false
            }
            let deltaY = (touchOriginPoint?.y)! - locationPoint.y
            if abs(deltaY) <= (touchCell?.bounds.height)!/2 {
                // no change
                print("no change")

            } else if deltaY > 0 {
                // up level
                if card.proficiency < 6 {
                    card.proficiency = card.proficiency + 1
                }
                print("up")

            } else {
                // down level
                if card.proficiency > 0 {
                    card.proficiency = card.proficiency - 1
                }
                print("down")
            }

            removeGotAndStudyView()

        default:
            break

        }
    }

    func handleSwipe(swipeRecognizer: UISwipeGestureRecognizer) {
        switch swipeRecognizer.direction {
        case UISwipeGestureRecognizerDirection.Left :
            print("Left")
        case UISwipeGestureRecognizerDirection.Right :
            print("Right")
        case UISwipeGestureRecognizerDirection.Up :
            print("Left")
        case UISwipeGestureRecognizerDirection.Down :
            print("Right")
        default :
            break
        }
    }

}

// MARK : Got and Study View
extension PaceCardCollectionViewController {

    func addGotAndStudyViewAtFrame(frame : CGRect, belowView: UIView) {
        gotView.alpha = 0.0
        studyView.alpha = 0.0
        self.collectionView?.insertSubview(gotView, belowSubview: belowView)
        self.collectionView?.insertSubview(studyView, belowSubview: belowView)
        gotView.frame = frame
        studyView.frame = frame
    }

    func gotAndStudyViewMovedY(movedY: CGFloat, threshold: CGFloat) {

        if movedY >= 0 {
            studyView.alpha = 0.0
            gotView.alpha = threshold > movedY ? movedY / threshold : 1.0
        } else {
            gotView.alpha = 0.0
            studyView.alpha = threshold > abs(movedY) ? abs(movedY) / threshold : 1.0
        }
    }

    func removeGotAndStudyView() {
        gotView.removeFromSuperview()
        studyView.removeFromSuperview()
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

        let card = fetchedResultsController.objectAtIndexPath(indexPath) as! MOCard
        cell.cardView.frontView.wordLabel.text = card.definition?.word?.word
        cell.cardView.frontView.syllablesLabel.text = card.definition?.word?.syllables
        cell.cardView.frontView.pronunciationLabel.text = card.definition?.word?.pronunciation

        cell.cardView.backView.definitionLabel.text = card.definition?.definitoin

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

