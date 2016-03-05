//
//  DeckListTableViewCell.swift
//  Pace
//
//  Created by lee on 3/5/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit

class DeckListTableViewCell: UITableViewCell {

    @IBOutlet weak var deckTitleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
