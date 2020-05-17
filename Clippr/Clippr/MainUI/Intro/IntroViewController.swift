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
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        animationView.play(fromMarker: nil, toMarker: "button") { [weak self] _ in
            self?.showNextButton = true
        }
    }
    
    @IBAction func next(_ sender: Any) {
        showNextButton = false
        animationView.play { [weak self] _ in
            self?.completion?()
        }
    }
}
