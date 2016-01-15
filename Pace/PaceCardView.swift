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


    @IBOutlet var view: UIView!
    @IBOutlet var backView: PaceCardBackView!
    @IBOutlet var frontView: PaceCardFrontView!

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

//        setup()

    }

    override init(frame: CGRect) {

        super.init(frame: frame)

        setup()
    }

    func setup() {

        NSBundle.mainBundle().loadNibNamed("PaceCardView", owner: self, options: nil)


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
//                UIView.transitionFromView(backView, toView: frontView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            case .Back :

                let transitionOptions: UIViewAnimationOptions = [.TransitionFlipFromLeft, .ShowHideTransitionViews]

                UIView.transitionWithView(frontView, duration: 1.0, options: transitionOptions, animations: {
                    self.frontView.hidden = true
                    }, completion: nil)

                UIView.transitionWithView(backView, duration: 1.0, options: transitionOptions, animations: {
                    self.backView.hidden = false
                    }, completion: nil)

//                UIView.transitionFromView(frontView, toView: backView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)

            }

        }


    }

    func flip() {
        switch face {
        case .Front :
            face = .Back
        case .Back :
            face = .Front
        }
    }

}
