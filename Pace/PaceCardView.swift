//
//  PaceCardView.swift
//  Pace
//
//  Created by lee on 1/15/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit


@IBDesignable
class PaceCardView: UIView {


    var view: UIView!
    @IBOutlet var backView: PaceCardBackView!
    @IBOutlet var frontView: PaceCardFrontView!


    let nibName = "PaceCardView"

    enum PaceCardFace {
        case Front
        case Back
    }

    var face : PaceCardFace = .Front {

        didSet{

            setFace(face, fromFace: oldValue)

        }
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

        xibSetUp()

    }

    override init(frame: CGRect) {

        super.init(frame: frame)

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

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        frontView.wordLabel.text = "test"

    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}


// MARK: animating func
extension PaceCardView {

    func setFace(face: PaceCardFace, fromFace: PaceCardFace) {

        // animating to flip
        if face != fromFace {

            switch face {
            case .Front :

                let transitionOptions: UIViewAnimationOptions = [.TransitionFlipFromRight, .ShowHideTransitionViews]

                UIView.transitionWithView(backView, duration: 1.0, options: transitionOptions, animations: {
                    self.backView.hidden = true
                    }, completion: nil)

                UIView.transitionWithView(frontView, duration: 1.0, options: transitionOptions, animations: {
                    self.frontView.hidden = false
                    }, completion: nil)

            case .Back :

                let transitionOptions: UIViewAnimationOptions = [.TransitionFlipFromLeft, .ShowHideTransitionViews]

                UIView.transitionWithView(frontView, duration: 1.0, options: transitionOptions, animations: {
                    self.frontView.hidden = true
                    }, completion: nil)

                UIView.transitionWithView(backView, duration: 1.0, options: transitionOptions, animations: {
                    self.backView.hidden = false
                    }, completion: nil)

            }

        }


    }

    func flip() {
        switch face {
        case .Front :
            face = .Back
//            setFace(.Back, fromFace: .Front)
        case .Back :
            face = .Front
//            setFace(.Front, fromFace: .Back)
        }
    }

}
