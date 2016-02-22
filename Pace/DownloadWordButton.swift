//
//  DownloadWordButton.swift
//  Pace
//
//  Created by lee on 2/20/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit

class DownloadWordButton: UIButton {


    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.clipsToBounds = true

        let isNeedBorder = self.downloadState != .HasDownloaded || self.frequencyView.rank == .Undefine
        self.layer.borderColor = isNeedBorder ? self.tintColor.CGColor : UIColor.clearColor().CGColor


    }

    var frequencyView: FrequencyView!

    var rank : FrequencyRank {
        get{
            return frequencyView.rank
        }
        set{

            if newValue != rank {
                setNeedsDisplay()
                frequencyView.rank = newValue
            }
        }
    }

    @IBInspectable  var downloadState: WordDownloadState = .NeedsDownload {
        didSet{
            if oldValue != downloadState {
                changeState(downloadState)
            }
        }
    }



    func changeState(state: WordDownloadState) {


        self.alpha = 0.0
        defer {
            UIView.animateWithDuration(0.5) { () -> Void in
                self.alpha = 1.0
            }
            setNeedsDisplay()

        }

        switch state{
        case .NeedsDownload:
            print("show downlaod icon")
            if self.subviews.contains(frequencyView) {
                frequencyView.removeFromSuperview()
            }
            self.enabled = true
            self.imageView?.layer.removeAllAnimations()

        case .Downloading:
            print("show loading animate\(self.imageView)")
            if self.subviews.contains(frequencyView) {
                frequencyView.removeFromSuperview()
            }
            self.enabled = false

            let kAnimationKey = "rotation"

            if self.layer.animationForKey(kAnimationKey) == nil {

                let rotateAnimate = CABasicAnimation(keyPath: "transform.rotation")
                rotateAnimate.toValue = Float(2.0 * M_PI)
                rotateAnimate.duration = 1.0
                rotateAnimate.fromValue = 0.0
                rotateAnimate.repeatCount = Float.infinity
                self.imageView?.layer.addAnimation(rotateAnimate, forKey: kAnimationKey)
            }
            print("show loading animate\(self.imageView)")

        case .HasDownloaded:
            print("show frequency view\(self.imageView)")
            self.imageView?.layer.removeAllAnimations()
            self.enabled = self.frequencyView.rank == .Undefine ? true : false
            guard self.subviews.contains(frequencyView) else {
                self.addSubview(frequencyView)
                return
            }
        }


    }

    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.alpha = 0.0
        frequencyView = FrequencyView(frame: self.bounds)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.alpha = 0.0
        frequencyView = FrequencyView(frame: self.bounds)

    }

}
