//
//  ColorClipboardItem.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/12/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Cocoa

class ColorClipboardItem: ClipboardItem {
    override var type: ItemType { .color }
    @objc dynamic var color: NSColor {
        if let data = types[.color],
           let result = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSColor {
            return result
        }
        return .clear
    }
}
