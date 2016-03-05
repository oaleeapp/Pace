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

    var level: WordDefinitionProficiencyLevel = .Never
    var partOfSpeechColor: UIColor = UIColor(themeColor: .LightBackgroundColor) {
        didSet{
            frontView.partOfSpeechIndicateView.backgroundColor = partOfSpeechColor
            backView.partOfSpeechIndicateView.backgroundColor = partOfSpeechColor
        }
    }
    enum PaceCardFace {
        case Front
        case Back
    }

    private(set) var face : PaceCardFace = .Front

    func setFace(face: PaceCardFace, withAnimated animated: Bool) {
        if self.face != face {

            self.face = face
            animated ? flipAnimate() : switchViews()
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
        self.layer.cornerRadius = 15.0
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.view.layer.cornerRadius = 15.0
        self.view.clipsToBounds = true
        self.view.layer.masksToBounds = true
        self.backgroundColor = UIColor(themeColor: .LightBackgroundColor)
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

    func flipAnimate() {
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

    func switchViews() {

        switch face {
        case .Front :
            backView.hidden = true
            frontView.hidden = false
        case .Back :
            frontView.hidden = true
            backView.hidden = false
        }
    }

    func flip() {
        switch face {
        case .Front :
            setFace(.Back, withAnimated: true)

        case .Back :
            setFace(.Front, withAnimated: true)

        }
    }

}
