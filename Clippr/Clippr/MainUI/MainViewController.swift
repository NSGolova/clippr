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
    
    var keylessWindow: KeylessWindow? { view.window as? KeylessWindow }
    
    override func viewDidAppear() {
        keylessWindow?.ableToKey = false
    }
    
//    @IBAction func changeSavingMethod(_ sender: NSButton) {
//        if let savingMethod = SavingMethod(rawValue: sender.tag) {
//            Preferences.savingMethod = savingMethod
//        }
//    }
}
