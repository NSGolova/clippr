//
//  RTFClipboardItem.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/10/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Cocoa

class RTFClipboardItem: ClipboardItem {
    @objc dynamic let attributedString: NSAttributedString
    
    override var data: Data? {
        attributedString.rtf(from: NSRange(location: 0, length: attributedString.length), documentAttributes: [:])
    }
    
    init(name: String, attributedString: NSAttributedString, source: NSRunningApplication) {
        self.attributedString = attributedString
        
        super.init(name: name, type: .rtf, source: source)
    }
}
