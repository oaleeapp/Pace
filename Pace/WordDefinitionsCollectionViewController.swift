//
//  WordDefinitionsCollectionViewController.swift
//  Pace
//
//  Created by lee on 1/3/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit
import CoreData

class WordDefinitionsCollectionViewController: UICollectionViewController {

    let cellIdentifier = "DefinitionCell"
    var shouldReloadCollectionView = false
    var blockOperation : NSBlockOperation?
    var managedObjectContext : NSManagedObjectContext?
    var word : MOWord?
    lazy var fetchedResultsController : NSFetchedResultsController = {

        let wordFetchRequest = NSFetchRequest(entityName: MODefinition.entityName())
        let primarySortDescriptor = NSSortDescriptor(key: "partOfSpeech", ascending: true)
        let secondarySortDescriptor = NSSortDescriptor(key: "definitoin", ascending: true)
        wordFetchRequest.sortDescriptors = [primarySortDescriptor,secondarySortDescriptor]


        let frc = NSFetchedResultsController(fetchRequest: wordFetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)

        frc.delegate = self

        return frc
        
    }()

    func setUpManagedObjectContect(managedObjectContext: NSManagedObjectContext?, word: MOWord?) {

        self.managedObjectContext = managedObjectContext
        self.word = word
        guard let wordString = self.word?.word else {
            print("has no word managedObject exist")
            return
        }
        let predicate = NSPredicate(predicateIdentifier: .IsLikeString, wordString)
        fetchedResultsController.fetchRequest.predicate = predicate
        do {
            try fetchedResultsController.performFetch()
            collectionView?.reloadData()
        } catch {
            print("\(error)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var insets = collectionView!.contentInset
        let value = (self.view.frame.size.width - (collectionView!.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width) * 0.5
        insets.left = value
        insets.right = value
        collectionView!.contentInset = insets
        collectionView!.decelerationRate = UIScrollViewDecelerationRateFast;
    }

}

//MARK: - UICollectionView Delegate and DataSource

extension WordDefinitionsCollectionViewController {

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfRowForSection(section)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! WordDefinitionCell

        configureCell(cell, indexPath: indexPath)

        return cell

    }
    
}


// MARK: - NSFetchedResultsControllerDelegate
// FROM : https://gist.github.com/lukasreichart/0ce6b782a5428bd17904

extension WordDefinitionsCollectionViewController : NSFetchedResultsControllerDelegate{


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

    func configureCell(cell: WordDefinitionCell, indexPath: NSIndexPath) -> WordDefinitionCell {

        let definition = fetchedResultsController.objectAtIndexPath(indexPath) as! MODefinition
        cell.definitionLabel.text = definition.definitoin
        print(definition.details)

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