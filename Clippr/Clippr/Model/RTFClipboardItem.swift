//
//  RTFClipboardItem.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/10/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Cocoa

class RTFClipboardItem: ClipboardItem {
    override var type: ClipboardItem.ItemType { .attributedString }
    @objc dynamic var attributedString: NSAttributedString {
        if let data = types[.rtfd],
           let result = NSAttributedString(rtfd: data, documentAttributes: nil) {
            return result
        }
        
        if let data = types[.rtf],
           let result = NSAttributedString(rtf: data, documentAttributes: nil) {
            return result
        }
        
        return NSAttributedString()
    }
}
