//
//  ClipboardItem.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/10/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Cocoa

class ClipboardItem: NSObject, Codable {
    private enum CodingKeys : String, CodingKey {
        case name
        case author
        case source
        case creationDate
        case type
    }
    @objc dynamic var name: String
    let type: NSPasteboard.PasteboardType
    
    @objc dynamic let author: String
    @objc dynamic let source: ItemSource?
    @objc dynamic let creationDate: Date
    var data: Data? { name.data(using: .utf8) }
    
    init(name: String, type: NSPasteboard.PasteboardType?, source: NSRunningApplication) {
        self.name = name
        if let bundleURL = source.bundleURL {
            self.source = ItemSource(url: bundleURL)
        } else {
            self.source = nil
        }
        creationDate = Date()
        author = "MAC"
        self.type = type ?? .string
        
        super.init()
    }
    
    override func value(forUndefinedKey key: String) -> Any? {
        return nil
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.source = try container.decodeIfPresent(ItemSource.self, forKey: .source)
        self.author = try container.decode(String.self, forKey: .author)
        self.creationDate = try container.decode(Date.self, forKey: .creationDate)
        self.type = NSPasteboard.PasteboardType(rawValue: try container.decode(String.self, forKey: .type))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(author, forKey: .author)
        try container.encode(name, forKey: .name)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(source, forKey: .source)
        try container.encode(type.rawValue, forKey: .type)
    }
}

extension NSPasteboard.PasteboardType: ClassFamily {
    static var discriminator: Discriminator = .type
    
    func getType() -> AnyObject.Type {
        switch self {
        case .rtf:
            return RTFClipboardItem.self
        case .tiff:
            return ImageClipboardItem.self
        default:
            return ClipboardItem.self
        }
    }
}
