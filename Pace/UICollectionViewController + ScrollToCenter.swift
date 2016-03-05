//
//  UICollectionView + ScrollToCenter.swift
//  Pace
//
//  Created by lee on 3/5/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit

extension UICollectionViewController {
    func cellToCenter() {
        guard let visibleCells = collectionView?.visibleCells() else {
            return
        }

        guard !(visibleCells.isEmpty) else {
            return
        }

        let centerX = collectionView?.bounds.midX
        var middleCell = visibleCells.first
        var deltaX = abs((middleCell?.frame.midX)! - centerX!)
        for cell in visibleCells {
            let cellDeltaX = abs(cell.frame.midX - centerX!)
            if cellDeltaX < deltaX {
                middleCell = cell
                deltaX = cellDeltaX
            }
        }
        let indexPath = collectionView?.indexPathForCell(middleCell!)
        collectionView?.scrollToItemAtIndexPath(indexPath!, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
    }
}
