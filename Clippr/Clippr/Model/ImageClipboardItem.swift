//
//  ImageClipboardItem.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/10/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Cocoa

class ImageClipboardItem: ClipboardItem {
    private enum CodingKeys : String, CodingKey {
        case image
    }
    @objc dynamic var image: NSImage
    override var data: Data? { image.tiffRepresentation }
    
    init(name: String, image: NSImage, source: NSRunningApplication) {
        self.image = image
        
        super.init(name: name, type: NSPasteboard.PasteboardType.tiff, source: source)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.image = NSImage(data: try container.decode(Data.self, forKey: .image)) ?? NSImage()
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(data, forKey: .image)
        
        try super.encode(to: encoder)
    }
}
