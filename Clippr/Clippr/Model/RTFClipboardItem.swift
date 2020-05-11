//
//  RTFClipboardItem.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/10/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Cocoa

class RTFClipboardItem: ClipboardItem {
    private enum CodingKeys : String, CodingKey {
        case attributedString
    }
    @objc dynamic var attributedString: NSAttributedString
    
    override var data: Data? {
        attributedString.rtf(from: NSRange(location: 0, length: attributedString.length), documentAttributes: [:])
    }
    
    init(name: String, attributedString: NSAttributedString, source: NSRunningApplication) {
        self.attributedString = attributedString
        
        super.init(name: name, type: .rtf, source: source)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.attributedString = NSAttributedString(rtf: try container.decode(Data.self, forKey: .attributedString), documentAttributes: nil) ?? NSAttributedString()
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(data, forKey: .attributedString)
        
        try super.encode(to: encoder)
    }
}
