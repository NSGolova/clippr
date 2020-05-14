//
//  FileClipboardItem.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/12/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Cocoa

class FileClipboardItem: ImageClipboardItem {
    override var type: ClipboardItem.ItemType { .file }
    override var name: String {
        if #available(OSX 10.13, *) {
            if let data = types[.fileURL],
               let result = NSURL(absoluteURLWithDataRepresentation: data, relativeTo: nil).path {
                return result
            }
        } else {
        }
        return super.name
    }
    
    override var image: NSImage {
        NSWorkspace.shared.icon(forFile: name)
    }
}
