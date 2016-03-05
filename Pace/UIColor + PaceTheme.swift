//
//  UIColor + PaceTheme.swift
//  Pace
//
//  Created by lee on 1/9/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(themeColor: ThemeColor) {
        let hexString = themeColor.rawValue
        self.init(hexString: hexString)
    }

    convenience init(hexString: String) {
        let hex = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        var int = UInt32()
        NSScanner(string: hex).scanHexInt(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

    enum DeckColor : String {
        case Violet = "5856D6"
        case Indigo = "007AFF"
        case Blue = "34AADC"
        case Green = "4CD964"
        case Yellow = "FFCC00"
        case Orange = "FF9500"
        case Red = "FF3B30"

    }

    enum ThemeColor : String {
        case LightThemeColor = "007AFF"
        case LightBackgroundColor = "F7F7F7"
        case LightCardBackgroundColor = "E9D460"
        case LightTextColor = "141414"
        case LightDescribeColor = "D2D7D3"
        case LightLevelUpColor = "E74C3C"
        case LightLevelDownColor = "2ECC71"
    }
}
