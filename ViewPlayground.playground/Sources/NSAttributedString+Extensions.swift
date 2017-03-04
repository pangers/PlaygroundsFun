//
//  NSAttributedString+Extensions.swift
//  NextFerry
//
//  Created by James Pang on 19/11/16.
//  Copyright © 2016 James Pang. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    
    func demiBold(sized size: CGFloat) -> NSAttributedString {
        guard !string.isEmpty else { return self }
        
        let mutable = mutableCopy() as! NSMutableAttributedString
        
        let attribute = [
            NSFontAttributeName : UIFont.demiBoldFont(with: size)
        ]
        
        mutable.addAttributes(attribute, range: NSRange(location: 0, length: string.characters.count))
        
        return mutable
    }
    
    func bold(sized size: CGFloat) -> NSAttributedString {
        guard !string.isEmpty else { return self }
        
        let mutable = mutableCopy() as! NSMutableAttributedString
        
        let attribute = [
            NSFontAttributeName : UIFont.boldFont(with: size)
        ]
        
        mutable.addAttributes(attribute, range: NSRange(location: 0, length: string.characters.count))
        
        return mutable
    }
    
    func medium(sized size: CGFloat) -> NSAttributedString {
        guard !string.isEmpty else { return self }
        
        let mutable = mutableCopy() as! NSMutableAttributedString
        
        let attribute = [
            NSFontAttributeName : UIFont.mediumFont(with: size)
        ]
        
        mutable.addAttributes(attribute, range: NSRange(location: 0, length: string.characters.count))
        
        return mutable
    }
    
    func colored(_ color: UIColor) -> NSAttributedString {
        guard !string.isEmpty else { return self }
        
        let mutable = mutableCopy() as! NSMutableAttributedString
        
        let attribute = [
            NSForegroundColorAttributeName : color
        ]
        
        mutable.addAttributes(attribute, range: NSRange(location: 0, length: string.characters.count))
        
        return mutable
    }
    
    func align(_ alignment: NSTextAlignment) -> NSAttributedString {
        guard !string.isEmpty else { return self }
        
        let mutable = mutableCopy() as! NSMutableAttributedString
        
        let style = mutable.attribute(NSParagraphStyleAttributeName, at: 0, longestEffectiveRange: nil, in: NSMakeRange(0, string.characters.count)) as? NSParagraphStyle
        
        let pStyle = (style?.mutableCopy() as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
        
        pStyle.alignment = alignment
        
        let attribute = [
            NSParagraphStyleAttributeName : pStyle
        ]
        
        mutable.addAttributes(attribute, range: NSRange(location: 0, length: string.characters.count))
        
        return mutable
    }
    
    func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> NSAttributedString {
        guard !string.isEmpty else { return self }
        
        let mutable = mutableCopy() as! NSMutableAttributedString
        
        let style = mutable.attribute(NSParagraphStyleAttributeName, at: 0, longestEffectiveRange: nil, in: NSMakeRange(0, string.characters.count)) as? NSParagraphStyle
        
        let pStyle = (style?.mutableCopy() as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
        
        pStyle.lineBreakMode = lineBreakMode
        
        let attribute = [
            NSParagraphStyleAttributeName : pStyle
        ]
        
        mutable.addAttributes(attribute, range: NSRange(location: 0, length: string.characters.count))
        
        return mutable
    }
}

func +(lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
    let mutable = lhs.mutableCopy() as! NSMutableAttributedString
    mutable.append(rhs)
    return mutable
}
