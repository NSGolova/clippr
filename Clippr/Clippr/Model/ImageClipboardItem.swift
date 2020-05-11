//
//  ImageClipboardItem.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/10/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Cocoa

class ImageClipboardItem: ClipboardItem {
    @objc dynamic var image: NSImage
    
    override var data: Data? {
        image.tiffRepresentation
    }
    
    init(name: String, image: NSImage, source: NSRunningApplication) {
        self.image = image
        
        super.init(name: name, type: NSPasteboard.PasteboardType.tiff, source: source)
    }
}
