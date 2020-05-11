//
//  Clipboard.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/10/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Cocoa
import Carbon

class Clipboard: NSObject {
    @objc dynamic var items = [ClipboardItem]()
    var lastChangeCount = 0
    
    lazy var pasteboard = NSPasteboard.general
    
    override init() {
        super.init()
        
        lastChangeCount = pasteboard.changeCount
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.checkPastebord()
        }
    }
    
    func checkPastebord() {
        guard pasteboard.changeCount > lastChangeCount,
              let currentRunningApp = (NSWorkspace.shared.runningApplications.first { $0.isActive }) else { return }

        var item: ClipboardItem? = nil

        if pasteboard.canReadObject(forClasses: [NSImage.self], options: nil) {
            if let data = pasteboard.data(forType: .tiff),
               let image = NSImage(data: data),
               let name = pasteboard.string(forType: .string) {
                item = ImageClipboardItem(name: name, image: image, source: currentRunningApp)
            }
        } else if pasteboard.canReadObject(forClasses: [NSAttributedString.self], options: nil) {
            if let data = pasteboard.data(forType: .rtf),
               let string = NSAttributedString(rtf: data, documentAttributes: nil),
               let name = pasteboard.string(forType: .string) {
                item = RTFClipboardItem(name: name, attributedString: string, source: currentRunningApp)
            }
        } else if pasteboard.canReadObject(forClasses: [NSString.self], options: nil) {
            if let name = pasteboard.string(forType: .string) {
                item = ClipboardItem(name: name, type: nil, source: currentRunningApp)
            }
        }
        
        if let item = item {
            items.append(item)
        }
        
        lastChangeCount = pasteboard.changeCount
    }
    
    func paste(item: ClipboardItem) {
        lastChangeCount += 1
        pasteboard.declareTypes([item.type], owner: nil)
        pasteboard.setData(item.data, forType: item.type)

        let sourceRef = CGEventSource(stateID: .combinedSessionState)
        if sourceRef == nil {
            print("No event source")
            return
        }
        let veeCode = kVK_ANSI_V
        let eventDown = CGEvent(keyboardEventSource: sourceRef, virtualKey: CGKeyCode(veeCode), keyDown: true)
        eventDown!.flags = CGEventFlags.maskCommand //  CGEventFlags(rawValue: CGEventFlags.maskCommand.rawValue | 0x000008)
        let eventUp = CGEvent(keyboardEventSource: sourceRef, virtualKey: CGKeyCode(veeCode), keyDown: false)
        eventUp!.flags = CGEventFlags.maskCommand
        if let eventDown = eventDown {
            eventDown.post(tap: .cghidEventTap)
        }
        if let eventUp = eventUp {
            eventUp.post(tap: .cghidEventTap)
        }
    }
}
