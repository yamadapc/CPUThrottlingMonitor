//
//  StatusBarController.swift
//  CPUThrottlingMonitor
//
//  Created by Pedro Tacla Yamada on 17/10/20.
//  Copyright © 2020 Pedro Tacla Yamada. All rights reserved.
//

import Foundation
import Cocoa

class StatusBarController {
    private let cpuThrottlingService: CPUThrottlingService
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem

    init(cpuThrottlingService: CPUThrottlingService, contentItem: NSMenuItem) {
        self.cpuThrottlingService = cpuThrottlingService
        statusBar = NSStatusBar.system
        // Creating a status bar item having a fixed length
        statusItem = statusBar.statusItem(withLength: 80)

        let menu = NSMenu()
        menu.addItem(contentItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "v0.0.1", action: nil, keyEquivalent: ""))
        let quitItem = NSMenuItem(title: "Quit", action: #selector(onQuit), keyEquivalent: "")
        quitItem.target = self
        quitItem.isEnabled = true
        menu.addItem(quitItem)
        statusItem.menu = menu

        if let statusBarButton = statusItem.button {
            statusBarButton.title = String(format: "CTM %3d%%", cpuThrottlingService.getCurrentSpeedLimit())
        }

        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
            if let statusBarButton = self.statusItem.button {
                statusBarButton.title = String(format: "CTM %3d%%", cpuThrottlingService.getCurrentSpeedLimit())
            }
        })
    }

    @objc func onQuit() {
        NSApp.terminate(self)
    }
}
