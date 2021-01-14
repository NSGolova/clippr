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
    @objc dynamic var clipboard = Clipboard(items: [])
    @objc dynamic var closeButtonHidden = false
    
    @objc dynamic var searchPhrase: String?
    @objc dynamic var filterPredicate: NSPredicate? {
        guard let searchPhrase = self.searchPhrase else { return nil }
        
        return NSPredicate { object, _ -> Bool in
            guard let item = object as? ClipboardItem else { return false }
            return item.name.contains(searchPhrase)
        }
    }
    
    @objc
    func keyPathsForValuesAffectingFilterPredicate() -> Set<String> { [#keyPath(searchPhrase)] }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        guard let window = window else { return }
        window.level = .mainMenu
        window.backgroundColor = .clear
        
        tableView.setDraggingSourceOperationMask(.copy, forLocal: false)
    }

    @IBAction func tableAction(_ sender: Any) {
        let selectedItem = clipboard.items[tableView.selectedRow]
        NSApp.hide(self)
        clipboard.paste(item: selectedItem)
    }

    @IBAction func closeWindow(_ sender: Any) {
        window?.delegate = nil
        close()
        window?.delegate = self
    }
    
    override func moveDown(_ sender: Any?) {
        var rowToSelect = 0
        if tableView.selectedRow != clipboard.items.count - 1 {
            rowToSelect = tableView.selectedRow + 1
        }
        tableView.selectRowIndexes(NSIndexSet(index: rowToSelect) as IndexSet, byExtendingSelection: false)
        tableView.scrollRowToVisible(rowToSelect)
        
        guard tableView.selectedRow >= 0 else { return }
        
        clipboard.paste(item: clipboard.items[tableView.selectedRow])
    }
    
    func openWindowAtCenter() {
        super.showWindow(nil)
        
        guard let window = window else { return }
        window.styleMask.insert(.fullSizeContentView)
        window.styleMask.insert(.titled)
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.center()
        tableView.reloadData()
    }
    
    var lastActive: NSRunningApplication?
    
    @IBAction override func showWindow(_ sender: Any?) {
        super.showWindow(sender)

        guard let window = window else { return }
        window.styleMask.remove(.fullSizeContentView)
        window.styleMask.remove(.titled)
        
        if sender == nil {
            let ourEvent = CGEvent(source: nil)
            var mouseLocation = ourEvent?.location ?? .zero
            mouseLocation.y = (NSScreen.main?.frame.size.height ?? 0.0) - mouseLocation.y + 10.0 - window.frame.height
            mouseLocation.x -= 10.0

            window.setFrameOrigin(mouseLocation)
        }
        tableView.reloadData()
        lastActive = NSWorkspace.shared.runningApplications.first { $0.isActive }
        
        guard tableView.selectedRow >= 0 else { return }
        
        clipboard.paste(item: clipboard.items[tableView.selectedRow])
    }
}

extension WindowController: NSTableViewDataSource {
    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool {
        for index in rowIndexes {
            pboard.write(item: clipboard.items[index])
        }
        return true
    }
}
