//
//  FrequencyView.swift
//  Pace
//
//  Created by lee on 2/20/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit

class FrequencyView: UIView {


    let space = CGFloat(2.0)
    let edgeInset = UIEdgeInsets(top: 5.0, left: 6.5, bottom: 5.0, right: 6.5)
    override func drawRect(rect: CGRect) {

        let backRect = UIBezierPath(rect: rect)
        UIColor.whiteColor().setFill()
        backRect.fill()

        let lineWidth = (rect.width - (edgeInset.left + edgeInset.right) - space * 4) / 5
        let maxLineLength = rect.height - edgeInset.top - edgeInset.bottom

        for lineIndex in 0..<FrequencyRank.lineCount {

            let startX = edgeInset.left + space * CGFloat(lineIndex) + lineWidth * CGFloat(lineIndex) + lineWidth / 2
            let startY = edgeInset.top + maxLineLength
            let length = CGFloat(FrequencyRank(rawValue: lineIndex + 1)!.lengthForMaxLength(Double(maxLineLength)))
            let startPoint = CGPoint(x: startX, y: startY)
            let endPoint = CGPoint(x: startPoint.x, y: startPoint.y - length)

            let path = UIBezierPath()
            path.moveToPoint(startPoint)
            path.addLineToPoint(endPoint)
            path.lineWidth = lineWidth

            let pathColor =
                lineIndex < self.rank.rawValue ? self.tintColor :
                self.rank == FrequencyRank.Undefine ? UIColor.lightGrayColor() : UIColor.clearColor()
            pathColor.setStroke()
            path.stroke()
        }

    }

    var rank : FrequencyRank = .Undefine {
        didSet{
            if oldValue != rank {
                setNeedsDisplay()
            }
        }
    }



    override init(frame: CGRect) {
        super.init(frame: frame)
        self.userInteractionEnabled = false
        self.opaque = false

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.userInteractionEnabled = false
        self.opaque = false

    }

}
