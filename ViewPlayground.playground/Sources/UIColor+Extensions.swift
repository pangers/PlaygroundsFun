//
//  UIColor+Extensions.swift
//  NextFerry
//
//  Created by James Pang on 19/11/16.
//  Copyright © 2016 James Pang. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    public static func yellowBackgroundTint() -> UIColor {
        return UIColor(red: 247.0 / 255.0, green: 209.0 / 255.0, blue: 64.0 / 255.0, alpha: 0.85)
    }
    
    public static func blueBackgroundTint() -> UIColor {
        return ferryBlue().withAlphaComponent(0.85)
    }
    
    public static func orangeBackgroundTint() -> UIColor {
        return ferryOrange().withAlphaComponent(0.85)
    }
    
    public static func ferryBlue() -> UIColor {
        return UIColor(red: 0 / 255, green: 73 / 255, blue: 144 / 255, alpha: 1)
    }
    
    public static func ferryOrange() -> UIColor {
        return UIColor(red: 241 / 255, green: 74 / 255, blue: 33 / 255, alpha: 1)
    }
}
