//
//  LevelCircleView.swift
//  Pace
//
//  Created by lee on 2/29/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit

@IBDesignable class LevelCircleView: UIView {

    let numberOfLevels = 6
    let π : CGFloat = CGFloat(M_PI)

   var counter: Int = 1 {
        didSet{
            setNeedsDisplay()
        }
    }
    var outlineColor: UIColor = UIColor(themeColor: .LightThemeColor)
    var counterColor: UIColor = UIColor(themeColor: .LightBackgroundColor)
    var arcWidth: CGFloat = 30

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        arcWidth = min(bounds.width, bounds.height) * 1 / 5
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)

        let startAngle: CGFloat = π / 2
        let endAngle: CGFloat = 5 * π / 2

        let path = UIBezierPath(arcCenter: center,
            radius: radius/2 - arcWidth/2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)

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
        let alpha = CGFloat(counter - 1) / 10.0 + 0.4
        outlineColor.colorWithAlphaComponent(alpha).setStroke()
        levelPath.stroke()


    }

    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


}
