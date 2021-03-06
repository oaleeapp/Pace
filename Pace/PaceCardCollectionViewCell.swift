//
//  PaceCardCollectionViewCell.swift
//  Pace
//
//  Created by lee on 1/15/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit

class PaceCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: PaceCardView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    func setUp() {
        self.layer.cornerRadius = 15.0
        self.clipsToBounds = true
    }



}
