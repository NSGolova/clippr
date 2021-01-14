//
//  Clipboard.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/10/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Cocoa
import Carbon

class Clipboard: NSObject, Codable {
    private enum CodingKeys : String, CodingKey {
        case items
    }
    @objc dynamic var items: [ClipboardItem]
    var lastChangeCount = 0
    
    lazy var pasteboard = NSPasteboard.general
    
    init(items: [ClipboardItem]) {
        self.items = items
        
        super.init()

        lastChangeCount = pasteboard.changeCount
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.checkPastebord()
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try container.decode([ClipboardItem].self, ofFamily: ClipboardItem.ItemType.self, forKey: .items)
        
        super.init()
        
        lastChangeCount = pasteboard.changeCount
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.checkPastebord()
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items, forKey: .items)
    }
    
    func checkPastebord() {
        guard pasteboard.changeCount > lastChangeCount,
              let currentRunningApp = (NSWorkspace.shared.runningApplications.first { $0.isActive }) else { return }
        
        for item in pasteboard.pasteboardItems ?? [] {
            items.insert(ClipboardItem.itemClass(for: item.types).init(item: item, source: currentRunningApp), at: 0)
        }
        
        lastChangeCount = pasteboard.changeCount
    }
    
    func paste(item: ClipboardItem) {
        lastChangeCount += 1
        pasteboard.write(item: item)
    }
}
