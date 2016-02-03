//
//  DefinitionDetailHeaderView.swift
//  Pace
//
//  Created by lee on 1/23/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit

protocol WordDetailDelegate {
    func showAlertAddDetailForKey(key: String)
}


@IBDesignable class DefinitionDetailHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var headerTitleLabel: UILabel!

    @IBOutlet weak var addDetailButton: UIButton!


    let nibName = "DefinitionDetailHeaderView"
    var view : UIView!
    var delegate : WordDetailDelegate?

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

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

    
    @IBAction func addDetail(sender: AnyObject) {

        delegate?.showAlertAddDetailForKey(headerTitleLabel.text!)
    }


}
