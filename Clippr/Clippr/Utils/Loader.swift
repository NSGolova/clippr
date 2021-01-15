//
//  Loader.swift
//  Clippr
//
//  Created by Viktor Radulov on 1/15/21.
//  Copyright © 2021 Viktor Radulov. All rights reserved.
//

import Foundation

struct LaunchctlRegistry: Codable {
    
    enum ProcessType: String, Codable {
        case background = "Background"
        case standard = "Standard"
        case adaptive = "Adaptive"
        case interactive = "Interactive"
    }
    
    enum SessionType: String, Codable {
        case background = "Background"
        case aqua = "Aqua"
        case loginWindow = "LoginWindow"
    }
    
    static let agentsPath = "/Library/LaunchAgents/"
    
    var disabled: Bool?
    var launchOnlyOnce: Bool?
    var keepAlive = true
    var sessionType: SessionType?
    let label: String
    let program: String
    var processType: ProcessType?
    var machServices: [String: Bool]?
    var runAtLoad: Bool?
    var arguments: [String]?
    
    var defaultPlistName: String {
        return label + ".plist"
    }
    
    private enum CodingKeys: String, CodingKey {
        var rawValue: String {
            switch self {
            case .disabled: return LAUNCH_JOBKEY_DISABLED
            case .keepAlive: return LAUNCH_JOBKEY_KEEPALIVE
            case .sessionType: return LAUNCH_JOBKEY_LIMITLOADTOSESSIONTYPE
            case .label: return LAUNCH_JOBKEY_LABEL
            case .program: return LAUNCH_JOBKEY_PROGRAM
            case .processType: return LAUNCH_JOBKEY_PROCESSTYPE
            case .machServices: return LAUNCH_JOBKEY_MACHSERVICES
            case .runAtLoad: return LAUNCH_JOBKEY_RUNATLOAD
            case .arguments: return LAUNCH_JOBKEY_PROGRAMARGUMENTS
            case .launchOnlyOnce: return LAUNCH_JOBKEY_LAUNCHONLYONCE
            }
        }
        
        case disabled
        case keepAlive
        case sessionType
        case label
        case program
        case processType
        case machServices
        case runAtLoad
        case arguments
        case launchOnlyOnce
    }
    
    init?(bundle: Bundle) {
        guard let bundleIdentifier = bundle.bundleIdentifier,
              let executablePath = bundle.executablePath else { return nil }
        self.init(label: bundleIdentifier, program: executablePath)
    }
    
    init(label: String, program: String) {
        self.label = label
        self.program = program
    }
}

class Loader {
    static let appBundle = Bundle.main
    static let bundleIdentifier = appBundle.bundleIdentifier!
    static let pathToLaunchPlist = NSHomeDirectory() + LaunchctlRegistry.agentsPath + bundleIdentifier + ".plist"

    static func unloadAgent() {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: pathToLaunchPlist) {
            Process.launchedProcess(launchPath: "/bin/launchctl", arguments: ["unload", pathToLaunchPlist]).waitUntilExit()
            try? fileManager.removeItem(atPath: pathToLaunchPlist)
        }
    }

    static func loadAgent() {
        var registry = LaunchctlRegistry(bundle: appBundle)!
        registry.processType = .interactive
        registry.sessionType = .aqua
        registry.disabled = false
        registry.launchOnlyOnce = true
        registry.arguments = [appBundle.executablePath!, "fromLaunchd"]
        try? FileManager.default.createDirectory(atPath: NSHomeDirectory() + LaunchctlRegistry.agentsPath, withIntermediateDirectories: false, attributes: [:])
        try! (try! PropertyListEncoder().encode(registry)).write(to: URL(fileURLWithPath: pathToLaunchPlist))
        Process.launchedProcess(launchPath: "/bin/launchctl", arguments: ["load", pathToLaunchPlist])
    }
}
