//
//  ImageClipboardItem.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/10/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Cocoa

class ImageClipboardItem: ClipboardItem {
    override var type: ItemType { .image }
    @objc dynamic var image: NSImage {
        if let data = types[.tiff],
           let result = NSImage(data: data) {
            return result
        }
        if let data = types[.png],
           let result = NSImage(data: data) {
            return result
        }
        if let data = types[.pdf],
           let result = NSImage(data: data) {
            return result
        }
        return NSImage()
    }
}
