//
//  PaceCardStackView.swift
//  Pace
//
//  Created by lee on 1/22/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit

@IBDesignable class PaceCardStackView: UIView {

    @IBInspectable var offSet : CGFloat = 5
    @IBInspectable var cornerOffSet : CGFloat = 5
    @IBInspectable var cardColor : UIColor = UIColor.redColor()
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {

        let x = bounds.origin.x
        let y = bounds.origin.y
        let width = bounds.size.width
        let height = bounds.size.height - 30


        let tlControlPoint = CGPoint(x: x + offSet, y: y)
        let tlPointA = CGPoint(x: tlControlPoint.x, y: tlControlPoint.y + cornerOffSet)
        let tlPointB = CGPoint(x: tlControlPoint.x + cornerOffSet, y: tlControlPoint.y)

        let trControlPoint = CGPoint(x: x + width - offSet, y: y)
        let trPointA = CGPoint(x: trControlPoint.x  - cornerOffSet, y: trControlPoint.y)
        let trPointB = CGPoint(x: trControlPoint.x, y: trControlPoint.y + cornerOffSet)

        let brControlPoint = CGPoint(x: x + width, y: y + height)
        let brPointA = CGPoint(x: brControlPoint.x, y: brControlPoint.y - cornerOffSet)
        let brPointB = CGPoint(x: brControlPoint.x - cornerOffSet, y: brControlPoint.y)

        let blControlPoint = CGPoint(x: x, y: y + height)
        let blPointA = CGPoint(x: blControlPoint.x + cornerOffSet, y: blControlPoint.y)
        let blPointB = CGPoint(x: blControlPoint.x, y: blControlPoint.y - cornerOffSet)


        let path = UIBezierPath()
        path.moveToPoint(tlPointA)
        path.addCurveToPoint(tlPointB, controlPoint1: tlControlPoint, controlPoint2: tlControlPoint)
        path.addLineToPoint(trPointA)
        path.addCurveToPoint(trPointB, controlPoint1: trControlPoint, controlPoint2: trControlPoint)
        path.addLineToPoint(brPointA)
        path.addCurveToPoint(brPointB, controlPoint1: brControlPoint, controlPoint2: brControlPoint)
        path.addLineToPoint(blPointA)
        path.addCurveToPoint(blPointB, controlPoint1: blControlPoint, controlPoint2: blControlPoint)

        path.closePath()

        cardColor.setFill()
        path.fill()

    }

    func setUpLayer() {
//        layer.backgroundColor = UIColor.blueColor().CGColor
//        layer.borderWidth = 100.0
//        layer.borderColor = UIColor.redColor().CGColor
//        layer.shadowOpacity = 0.2
//        layer.shadowRadius = 10.0
//        layer.shadowOffset = CGSize(width: 0, height: 20.0)
//        self.transform = CGAffineTransformIdentity
//
//        self.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 2))
//        self.transform = CGAffineTransformMakeTranslation(-256, -256)
        layer.transform = CATransform3DMakeScale(1.2, 1.2, 0.0)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpLayer()
    }

}
