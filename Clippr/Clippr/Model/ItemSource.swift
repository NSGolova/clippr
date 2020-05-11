//
//  ItemSource.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/12/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Cocoa

class ItemSource: NSObject, Codable {
    private enum CodingKeys : String, CodingKey {
        case url
    }
    let url: URL
    @objc dynamic var icon: NSImage { NSWorkspace.shared.icon(forFile: url.path) }
    
    private let bundle: Bundle
    
    init?(url: URL) {
        guard let bundle = Bundle(url: url) else { return nil }
        
        self.url = url
        self.bundle = bundle
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.url = try container.decode(URL.self, forKey: .url)
        if let bundle = Bundle(url: url) {
            self.bundle = bundle
        } else {
            self.bundle = Bundle.main
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(url, forKey: .url)
    }
}
