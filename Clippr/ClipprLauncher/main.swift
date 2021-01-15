//
//  main.swift
//  ClipprLauncher
//
//  Created by Viktor Radulov on 1/14/21.
//  Copyright © 2021 Viktor Radulov. All rights reserved.
//

import Cocoa

if !mainApplicationRunning() {
    runMainApplication()
}

private func mainApplicationRunning() -> Bool {
    let mainBundleUrl = mainApplicationBundleUrl()
    return NSWorkspace.shared.runningApplications.contains { $0.bundleURL == mainBundleUrl }
}

private func mainApplicationBundleUrl() -> URL {
    return (1...4).reduce(Bundle.main.bundleURL, { url, _ in url.deletingLastPathComponent() })
}

private func runMainApplication() {
    try! NSWorkspace.shared.launchApplication(at: mainApplicationBundleUrl(), options: .default, configuration: [:])
}
