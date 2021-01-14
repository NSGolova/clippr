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
    var pressed: Bool = false
    
    @DefaultsStored("clipboard") @objc dynamic var clipboard = Clipboard(items: ClipboardItem.defaultItems)
    @DefaultsStored("introShown") @objc dynamic var introShown = false
    
    var timer: Timer? {
        didSet {
            oldValue?.invalidate()
        }
    }
    
    var introViewController: IntroViewController?
    lazy var mainViewController = MainViewController()
    var lastCommandDate = NSDate()
    
    func setupShortcut() {
        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { [weak self] event in
            guard let self = self else { return }
            
            self.process(event: event)
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { [weak self] event -> NSEvent? in
            guard let self = self else { return event }
            
            self.process(event: event)
            self.window.makeKeyAndOrderFront(nil)
            
            return event
        }
    }
    
    func process(event: NSEvent) {
        if event.modifierFlags.contains(.command) {
            lastCommandDate = NSDate()
            if timer == nil {
                timer = Timer.scheduledTimer(withTimeInterval: Preferences.showTimeInterval, repeats: false, block: { [weak self] _ in
                    guard let self = self else { return }
                    if self.pressed {
                        self.windowController?.close()
                        self.pressed = false
                    } else {
                        self.windowController?.showWindow(nil)
                        self.pressed = true
                    }
                })
            }
        } else {
            timer = nil
            
            guard pressed else { return }
            if abs(lastCommandDate.timeIntervalSinceNow) >= Preferences.moveTimeInterval &&
               windowController?.window?.isVisible == true {
                windowController?.moveDown(nil)
            }
        }
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
