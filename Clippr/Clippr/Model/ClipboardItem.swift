//
//  ClipboardItem.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/10/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Cocoa

class ClipboardItem: NSObject, Codable {
    enum ItemType: String, Codable {
        case unknown
        case image
        case color
        case file
        case attributedString
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case author
        case source
        case creationDate
        
        case type
        case types
    }
    
    @objc dynamic var name: String {
        if let data = types[.string],
           let result = String(data: data, encoding: .utf8) {
            return result
        } else {
            return ""
        }
    }
    @objc dynamic let author: String
    @objc dynamic let source: ItemSource?
    @objc dynamic let creationDate: Date
    
    var type: ItemType { .unknown }
    let types: [NSPasteboard.PasteboardType: Data]
    
    static func itemClass(for types: [NSPasteboard.PasteboardType]) -> ClipboardItem.Type {
        if types.contains(.rtf) ||
           types.contains(.rtfd) {
            return RTFClipboardItem.self
        }
        if types.contains(.tiff) ||
           types.contains(.png) ||
           types.contains(.pdf) {
            return ImageClipboardItem.self
        }
        if types.contains(.color) {
            return ColorClipboardItem.self
        }
        
        if #available(OSX 10.13, *) {
            if types.contains(.fileURL) {
                return FileClipboardItem.self
            }
        } else {
            //TODO: Find clipboard type of files on old systems
        }
        
        return ClipboardItem.self
    }
    
    required init(item: NSPasteboardItem, source: NSRunningApplication) {
        var types = [NSPasteboard.PasteboardType: Data]()
        for type in item.types {
            if let data = item.data(forType: type) {
                types[type] = data
            }
        }
        self.types = types
        if let bundleURL = source.bundleURL {
            self.source = ItemSource(url: bundleURL)
        } else {
            self.source = nil
        }
        creationDate = Date()
        author = "MAC"
        
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.source = try container.decodeIfPresent(ItemSource.self, forKey: .source)
        self.author = try container.decode(String.self, forKey: .author)
        self.creationDate = try container.decode(Date.self, forKey: .creationDate)
        
        var types = [NSPasteboard.PasteboardType: Data]()
        for (key, value) in try container.decode([String: Data].self, forKey: .types) {
            types[NSPasteboard.PasteboardType(rawValue: key)] = value
        }
        self.types = types
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(author, forKey: .author)
        try container.encode(name, forKey: .name)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(source, forKey: .source)
        try container.encode(type, forKey: .type)
        
        var types = [String: Data]()
        for (key, value) in self.types {
            types[key.rawValue] = value
        }
        
        try container.encode(types, forKey: .types)
    }
    
    // Bad hacks for using this class family in NSTableView
    override func value(forUndefinedKey key: String) -> Any? {
        return nil
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}

extension ClipboardItem.ItemType: ClassFamily {
    static var discriminator: Discriminator = .type
    
    func getType() -> AnyObject.Type {
        switch self {
        case .attributedString:
            return RTFClipboardItem.self
        case .image:
            return ImageClipboardItem.self
        case .color:
            return ColorClipboardItem.self
        default:
            return ClipboardItem.self
        }
    }
}
