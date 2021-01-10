//
//  KeyWindow.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/10/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Cocoa

class KeyWindow: NSWindow {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}

class KeylessWindow: NSWindow {
    var ableToKey = false
    
    override var canBecomeKey: Bool { ableToKey }
    override var canBecomeMain: Bool { ableToKey }
}
