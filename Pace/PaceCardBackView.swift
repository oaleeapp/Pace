//
//  PaceCardBackView.swift
//  Pace
//
//  Created by lee on 1/15/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit


@IBDesignable
class PaceCardBackView: UIView {


    
    @IBOutlet var view: UIView!
    @IBOutlet weak var definitionLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

//        setup()


    }

    override init(frame: CGRect) {

        super.init(frame: frame)

        setup()
    }

    func setup() {

        NSBundle.mainBundle().loadNibNamed("PaceCardBackView", owner: self, options: nil)

        view.frame = bounds

        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]

        self.addSubview(self.view)

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func prepareForInterfaceBuilder() {

    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
