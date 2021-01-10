//
//  IntroViewController.swift
//  Clippr
//
//  Created by Viktor Radulov on 5/14/20.
//  Copyright © 2020 Viktor Radulov. All rights reserved.
//

import Cocoa
import Lottie

class IntroViewController: NSViewController {

    @IBOutlet weak var animationView: AnimationView!
    
    @objc dynamic var showNextButton = false
    var completion: (() -> Void)?
    var keylessWindow: KeylessWindow? { view.window as? KeylessWindow }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func trusted() -> Bool {
        AXIsProcessTrusted()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        keylessWindow?.ableToKey = true
        
        if trusted() {
            animationView.imageProvider = EmptyImageProvider()
            animationView.textProvider = DictionaryTextProvider(["I need a permission from you": "Lets test your new\ncopy history",
                                                                 "Click the lock, type password, and check the box next to me  ":""])
            animationView.play(fromMarker: nil, toMarker: "button") { [weak self] _ in
                self?.showNextButton = true
            }
        } else {
            animationView.play(fromMarker: nil, toMarker: "permission") { [weak self] _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    Clipboard.perfromKeyDown()
                    NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
                    
                    self?.waitForTrusted()
                }
            }
        }
    }
    
    func waitForTrusted() {
        if trusted() {
            NSApp.activate(ignoringOtherApps: true)
            animationView.play(fromMarker: nil, toMarker: "button") { [weak self] _ in
                self?.showNextButton = true
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.waitForTrusted()
            }
        }
    }
    
    @IBAction func next(_ sender: Any) {
        showNextButton = false
        animationView.play { [weak self] _ in
            self?.completion?()
        }
    }
}

public final class EmptyImageProvider: AnimationImageProvider {
    public func imageForAsset(asset: ImageAsset) -> CGImage? {
        nil
    }
}
