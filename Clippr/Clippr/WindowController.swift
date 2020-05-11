//
//  WindowController.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/10/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, NSWindowDelegate {
    
    @IBOutlet weak var tableView: NSTableView!
    @objc dynamic var clipboard: Clipboard?
    
    @objc dynamic var searchPhrase: String?
    @objc dynamic var filterPredicate: NSPredicate? {
        guard let searchPhrase = self.searchPhrase else { return nil }
        
        return NSPredicate { object, _ -> Bool in
            guard let item = object as? ClipboardItem else { return false }
            return item.name.contains(searchPhrase)
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        window?.level = .mainMenu
        window?.backgroundColor = NSColor.clear
    }

    @IBAction func tableAction(_ sender: Any) {
        let selectedItem = clipboard!.items[tableView.selectedRow]
        NSApp.hide(self)
        clipboard!.paste(item: selectedItem)
    }

    @IBAction func closeWindow(_ sender: Any) {
        window?.delegate = nil
        close()
        window?.delegate = self
    }
    
    override func moveDown(_ sender: Any?) {
        var rowToSelect = 0
        if tableView.selectedRow != clipboard!.items.count - 1 {
            rowToSelect = tableView.selectedRow + 1
        }
        tableView.selectRowIndexes(NSIndexSet(index: rowToSelect) as IndexSet, byExtendingSelection: false)
        tableView.scrollRowToVisible(rowToSelect)
    }
    
    var lastActive: NSRunningApplication?
    
    @IBAction override func showWindow(_ sender: Any?) {
        super.showWindow(sender)

        if sender == nil {
            let ourEvent = CGEvent(source: nil)
            var mouseLocation = ourEvent?.location ?? .zero
            mouseLocation.y = (NSScreen.main?.frame.size.height ?? 0.0) - mouseLocation.y + 10.0
            mouseLocation.x -= 10.0

            window?.setFrameOrigin(mouseLocation)
        }
        tableView.reloadData()
        lastActive = NSWorkspace.shared.runningApplications.first { $0.isActive }
    }

    func windowWillClose(_ notification: Notification) {
        guard tableView.selectedRow >= 0 else { return }
        
        clipboard!.paste(item: clipboard!.items[tableView.selectedRow])
    }
    
    override func flagsChanged(with event: NSEvent) {
        lastActive?.activate(options: .activateIgnoringOtherApps)
        
        let itemToPaste = tableView.selectedRow >= 0 ? clipboard!.items[tableView.selectedRow] : nil
        
        closeWindow(self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            guard let itemToPaste = itemToPaste else { return }

            self.clipboard!.paste(item: itemToPaste)
        }
    }

}
