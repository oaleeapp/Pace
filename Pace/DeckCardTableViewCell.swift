//
//  DeckCardTableViewCell.swift
//  Pace
//
//  Created by lee on 3/5/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit

class DeckCardTableViewCell: UITableViewCell {

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!

    @IBOutlet weak var partOfSpeechLabel: UILabel!

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var partOfSpeechIndicateView: UIView!

    @IBOutlet weak var levelView: PaceLevelView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
