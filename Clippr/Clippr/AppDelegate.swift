//
//  AppDelegate.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/10/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Cocoa
import Carbon

extension FourCharCode: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: Self.StringLiteralType) {
        self.init()
        for char in value.utf16 {
          self = (self << 8) + FourCharCode(char)
        }
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    var windowController: WindowController?
    var hotKey: EventHotKeyRef?
    var pressed: Bool = false

    func registerShortcut() {
        let hotKeyID = EventHotKeyID(signature: "clip", id: FourCharCode("clip"))

        var hotKey: EventHotKeyRef? = nil
        RegisterEventHotKey(UInt32(kVK_ANSI_V), UInt32(optionKey), hotKeyID, GetApplicationEventTarget(), 0, &hotKey)
        self.hotKey = hotKey
    }
    
    func setupShortcut() {
        var eventHandlerRef: EventHandlerRef?
        var hotKeyPressedSpec = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        
        var eventHandlerRefRel: EventHandlerRef?
        var hotKeyReleasedSpec = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyReleased))
        
        InstallEventHandler(GetEventDispatcherTarget(), { _, event, _ -> OSStatus in
            guard let delegate = (NSApp.delegate as? AppDelegate) else { return noErr }
            delegate.pressed = true
            if delegate.windowController?.window?.isVisible != true {
                delegate.windowController?.showWindow(nil)
            } else {
                delegate.windowController?.moveDown(nil)
            }
            NSApp.activate(ignoringOtherApps: true)
            return noErr
        }, 1, &hotKeyPressedSpec, nil, &eventHandlerRef)
        
        InstallEventHandler(GetEventDispatcherTarget(), { _, event, context -> OSStatus in
            return noErr
        }, 1, &hotKeyReleasedSpec, nil, &eventHandlerRefRel)
        
        registerShortcut()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        windowController = WindowController(windowNibName: "Window")
        windowController?.clipboard = Clipboard()
        setupShortcut()
    }
}
