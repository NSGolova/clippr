//
//  MainViewController.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/14/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    @objc dynamic var saveToPreferences: Bool {
        get {
            Preferences.savingMethod == .preferences
        }
        set {
            if newValue {
                Preferences.savingMethod = .preferences
            } else {
                Preferences.savingMethod = .file
            }
        }
    }
    
    @objc
    func keyPathsForValuesAffectingSaveToPreferences() -> Set<String> { ["Preferences.savingMethod"] }
    
    @objc dynamic var showTimeInterval : TimeInterval {
        get {
            Preferences.showTimeInterval
        }
        set {
            Preferences.showTimeInterval = newValue
        }
    }
    
    @objc
    func keyPathsForValuesAffectingShowTimeInterval() -> Set<String> { ["Preferences.showTimeInterval"] }
    
    @objc dynamic var showTimeValue : Int {
        get {
            Int((showTimeInterval / 2.0) * 100)
        }
        set {
            showTimeInterval = (Double(newValue) / 100.0) * 2.0
        }
    }
    
    @objc
    func keyPathsForValuesAffectingShowTimeValue() -> Set<String> { [#keyPath(showTimeInterval)] }
    
    @objc dynamic var moveTimeInterval : TimeInterval {
        get {
            Preferences.moveTimeInterval
        }
        set {
            Preferences.moveTimeInterval = newValue
        }
    }
    
    @objc
    func keyPathsForValuesAffectingMoveTimeInterval() -> Set<String> { ["Preferences.moveTimeInterval"] }
    
    @objc dynamic var moveTimeValue : Int {
        get {
            Int((moveTimeInterval * 2.0) * 100)
        }
        set {
            let new = (Double(newValue) / 100.0) * 2.0
            if new < showTimeInterval {
                moveTimeInterval = new
            } else {
                moveTimeInterval = showTimeInterval
            }
        }
    }
    
    @objc
    func keyPathsForValuesAffectingMoveTimeValue() -> Set<String> { [#keyPath(moveTimeInterval)] }
    
    @objc dynamic var launchOnLogin: Bool {
        get {
            Preferences.launchOnLogin
        }
        set {
            Preferences.launchOnLogin = newValue
        }
    }
    
    @objc
    func keyPathsForValuesAffectingLaunchOnLogin() -> Set<String> { ["Preferences.launchOnLogin"] }
    
    var keylessWindow: KeylessWindow? { view.window as? KeylessWindow }
    
    override func viewDidAppear() {
        keylessWindow?.ableToKey = false
    }
    
    @IBAction func showHistory(_ sender: Any) {
        (NSApp.delegate as? AppDelegate)?.windowController?.showWindow(nil)
    }
    
    @IBAction func changeSavingMethod(_ sender: NSButton) {
        if let savingMethod = SavingMethod(rawValue: sender.tag) {
            Preferences.savingMethod = savingMethod
        }
    }
}
