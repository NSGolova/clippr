//
//  MenuItem.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/11/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Cocoa

class MenuItem {
    private lazy var statusItem = NSStatusBar.system.statusItem(withLength: 32)
    var openHandler: (() -> Void)?
    var clipboardHandler: (() -> Void)?
    
    func install() {
        self.statusItem.image = #imageLiteral(resourceName: "MAC")
            
        let menu = NSMenu()
        
        let windowItem = NSMenuItem(title: NSLocalizedString("Open Clippr!", comment: ""), action: #selector(self.window(sender:)), keyEquivalent: "")
        windowItem.target = self
        menu.addItem(windowItem)
        
        let clipboardItem = NSMenuItem(title: NSLocalizedString("Clipboard history", comment: ""), action: #selector(self.clipboard(sender:)), keyEquivalent: "")
        clipboardItem.target = self
        menu.addItem(clipboardItem)
        
        self.statusItem.menu = menu
    }
    
    @objc private
    func window(sender: Any) {
        openHandler?()
    }
    
    @objc private
    func clipboard(sender: Any) {
        clipboardHandler?()
    }
}
