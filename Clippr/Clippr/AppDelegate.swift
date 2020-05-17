//
//  AppDelegate.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/10/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Cocoa
import Carbon

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

    @IBOutlet weak var window: NSWindow! {
        didSet {
            window.styleMask.insert(.fullSizeContentView)
            window.styleMask.insert(.titled)
            window.standardWindowButton(.miniaturizeButton)?.isHidden = true
            window.standardWindowButton(.zoomButton)?.isHidden = true
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
        }
    }
    var windowController: WindowController?
    var menuItem: MenuItem?
    var hotKey: EventHotKeyRef?
    var pressed: Bool = false
    
    @DefaultsStored("clipboard") @objc dynamic var clipboard = Clipboard()
    //@DefaultsStored("introShown")
    @objc dynamic var introShown = false
    
    var introViewController: IntroViewController?
    lazy var mainViewController = MainViewController()

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
            if let updatedClipboard = delegate.windowController?.clipboard {
                delegate.clipboard = updatedClipboard
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
        windowController?.clipboard = clipboard
        
        menuItem = MenuItem()
        menuItem?.openHandler = { [weak self] in
            self?.handleOpen()
        }
        
        menuItem?.clipboardHandler = { [weak self] in
            guard let self = self else { return }
            
            self.windowController?.openWindowAtCenter()
        }
        menuItem?.install()
        
        setupShortcut()
        
        if !introShown {
            handleOpen()
        }
    }
    
    func handleOpen() {
        NSApp.setActivationPolicy(.regular)
        
        window.makeKeyAndOrderFront(nil)
        
        if !introShown {
            introViewController = IntroViewController()
            introViewController?.completion = { [weak self] in
                guard let self = self else { return }
                
                self.introShown = true
                self.introViewController = nil
                self.handleOpen()
            }
            window.contentViewController = introViewController
        } else {
            window.contentViewController = mainViewController
        }
    }
    
    func windowWillClose(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }
}
