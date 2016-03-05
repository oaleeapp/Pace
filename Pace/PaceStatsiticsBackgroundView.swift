//
//  PaceStatsiticsBackgroundView.swift
//  Pace
//
//  Created by lee on 3/4/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit

@IBDesignable class PaceStatsiticsBackgroundView: UIView {

    var levelCountArray: [Int] = [0, 0, 0, 0, 0, 0] {
        didSet{
            setNeedsDisplay()
        }
    }
    var startColor = UIColor(themeColor: .LightThemeColor)
    var endColor = UIColor(themeColor: .LightCardBackgroundColor).colorWithAlphaComponent(0.1)


    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let totalCount = levelCountArray.reduce(0, combine: {$0 + $1})

        let levelsPercentage = levelCountArray.map {Double($0) / Double(totalCount)}

        var accumulation: CGFloat = 0.0
        var heights: [CGFloat] = []
        for index in 0..<levelsPercentage.count {

            let height = rect.height * accumulation
            heights.append(height)
            accumulation += CGFloat(levelsPercentage[index])
        }

        for index in 0..<heights.count {

            let context = UIGraphicsGetCurrentContext()
            let alpha = (CGFloat(index) + 2.0) / 10.0
            let colors = [startColor.colorWithAlphaComponent(alpha).CGColor, endColor.CGColor]
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colorLocations:[CGFloat] = [0.0, 1.0]
            let gradient = CGGradientCreateWithColors(colorSpace,
                colors,
                colorLocations)

            //6 - draw the gradient
            let startPoint = CGPoint(x: 0, y: heights[index])
            let endPoint = CGPoint(x:0, y:rect.height)
            CGContextDrawLinearGradient(context,
                gradient,
                startPoint,
                endPoint,
                [])

            CGContextSaveGState(context)


            
            if totalCount == 0 {
                break
            }


        }


    }


}
