//
//  DeckCardSelectTableViewCell.swift
//  Pace
//
//  Created by lee on 3/5/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit

class DeckCardSelectTableViewCell: UITableViewCell {

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var partOfSpeechLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
