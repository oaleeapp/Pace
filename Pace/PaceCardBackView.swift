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


    
    var view: UIView!
    @IBOutlet weak var definitionLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

        xibSetup()

    }

    override init(frame: CGRect) {

        super.init(frame: frame)

        xibSetup()

    }

    func xibSetup() {
        view = loadViewFromNib()

        // use bounds not frame or it'll be offset
        view.frame = bounds

        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]

        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }

    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "PaceCardBackView", bundle: bundle)

        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }



    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        definitionLabel.text = "definition"
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
