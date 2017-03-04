//
//  UIFont+Extensions.swift
//  NextFerry
//
//  Created by James Pang on 20/11/16.
//  Copyright © 2016 James Pang. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    static func demiBoldFont(with size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-DemiBold", size: size)!
    }
    
    static func boldFont(with size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Bold", size: size)!
    }
    
    static func mediumFont(with size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Medium", size: size)!
    }
}
