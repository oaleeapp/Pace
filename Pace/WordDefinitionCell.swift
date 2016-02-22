//
//  WordDefinitionCell.swift
//  Pace
//
//  Created by lee on 1/4/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit

class WordDefinitionCell: UICollectionViewCell {

    @IBOutlet weak var definitionLabel: UILabel!

    let nibName = "WordDefinitionCell"
    var view : UIView!

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        xibSetUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        xibSetUp()
    }

    func xibSetUp() {
        // setup the view from .xib
        view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
    }

    func loadViewFromNib() -> UIView {
        // grabs the appropriate bundle
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView

        return view
    }
    

}
