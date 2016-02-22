//
//  WordListTableViewCell.swift
//  Pace
//
//  Created by lee on 2/20/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit

class WordListTableViewCell: UITableViewCell {

    @IBOutlet weak var downloadButton: DownloadWordButton!
    @IBOutlet weak var wordLebel: UILabel!
    let nibName = "WordListTableViewCell"
    var view : UIView!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
