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
    @IBOutlet weak var inputFIeld: NSTextField!
    
    @objc dynamic var showNextButton = false
    var completion: (() -> Void)?
    var keylessWindow: KeylessWindow? { view.window as? KeylessWindow }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        keylessWindow?.ableToKey = true
        keylessWindow?.makeKey()
        animationView.play(fromMarker: nil, toMarker: "button") { [weak self] _ in
            guard let self = self else { return }
            
            self.showNextButton = true
            DispatchQueue.main.async {
                self.view.window?.makeFirstResponder(self.inputFIeld)
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
