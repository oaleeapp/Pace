//
//  PaceLevelView.swift
//  Pace
//
//  Created by lee on 1/22/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit

@IBDesignable class PaceLevelView: UIView {

    let numberOfLevels = 6
    let π : CGFloat = CGFloat(M_PI)

    @IBInspectable var counter: Int = 3
    @IBInspectable var outlineColor: UIColor = UIColor.blueColor()
    @IBInspectable var counterColor: UIColor = UIColor.orangeColor()

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code

        // 1
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)

        // 2
        let radius: CGFloat = max(bounds.width, bounds.height)

        // 3
        let arcWidth: CGFloat = 30

        // 4
        let startAngle: CGFloat = π / 2
        let endAngle: CGFloat = 5 * π / 2

        // 5
        let path = UIBezierPath(arcCenter: center,
            radius: radius/2 - arcWidth/2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        
        // 6
        path.lineWidth = arcWidth
        counterColor.setStroke()
        path.stroke()

        let unitAngle : CGFloat = π / 3

        let levelEndAngle = CGFloat(counter) * unitAngle + startAngle

        let levelPath = UIBezierPath(arcCenter: center,
            radius: radius/2 - arcWidth/2,
            startAngle: startAngle,
            endAngle: levelEndAngle,
            clockwise: true)

        levelPath.lineWidth = arcWidth
        outlineColor.setStroke()
        levelPath.stroke()


    }

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }



}
