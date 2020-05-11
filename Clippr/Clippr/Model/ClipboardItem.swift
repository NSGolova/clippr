//
//  ClipboardItem.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/10/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Cocoa

class ClipboardItem: NSObject {
    @objc dynamic let name: String
    let type: NSPasteboard.PasteboardType
    
    @objc dynamic let author: String
    @objc dynamic let source: NSRunningApplication
    @objc dynamic let creationDate: NSDate
    var data: Data? {
        return name.data(using: .utf8)
    }
    
    init(name: String, type: NSPasteboard.PasteboardType?, source: NSRunningApplication) {
        self.name = name
        self.source = source
        creationDate = NSDate()
        author = "MAC"
        self.type = type ?? .string
        
        super.init()
    }
    
    override func value(forUndefinedKey key: String) -> Any? {
        return nil
    }
}
