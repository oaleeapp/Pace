//
//  WordDefinitionHeaderView.swift
//  Pace
//
//  Created by lee on 1/21/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit

class WordDefinitionHeaderView: UIView {

    
    @IBOutlet weak var wordLabel : UILabel!
    @IBOutlet weak var definitionTextView : UITextView!
    @IBOutlet weak var partOfSpeechLabel : UILabel!
    @IBOutlet weak var cardifyButton : UIButton!
    @IBOutlet weak var deleteDefinitionButton : UIButton!


    func setPartOfSpeech(partOfSpeech: String, withColor color: UIColor) {
        partOfSpeechLabel.text = partOfSpeech
        partOfSpeechLabel.textColor = color
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
