//
//  PaceLevelCollectionViewCell.swift
//  Pace
//
//  Created by lee on 1/22/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit

class PaceLevelCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var backView: UIView!

    @IBOutlet weak var levelView: PaceLevelView!

    @IBOutlet weak var countLabel: UILabel!

    @IBOutlet weak var levelNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        backView.layer.cornerRadius = 15.0
    }

}
