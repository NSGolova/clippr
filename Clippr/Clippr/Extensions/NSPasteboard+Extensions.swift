//
//  NSPasteboard+Extensions.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/14/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Cocoa

extension NSPasteboard {
    func write(item: ClipboardItem) {
        declareTypes(item.types.map { $0.key }, owner: nil)
        for (key, value) in item.types {
            setData(value, forType: key)
        }
    }
}
