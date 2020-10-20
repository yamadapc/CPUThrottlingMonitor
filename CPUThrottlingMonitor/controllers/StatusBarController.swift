//
//  StatusBarController.swift
//  CPUThrottlingMonitor
//
//  Created by Pedro Tacla Yamada on 17/10/20.
//  Copyright © 2020 Pedro Tacla Yamada. All rights reserved.
//

import Foundation
import Cocoa
import Logging

class StatusBarController : NSObject, NSMenuDelegate {
    private static let logger = Logger(label: "com.beijaflor.StatusBarController")

    private let cpuThrottlingService: CPUThrottlingService
    private let analyticsService: AnalyticsService
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private let onClickSettingsCallback: () -> Void

    init(
        cpuThrottlingService: CPUThrottlingService,
        analyticsService: AnalyticsService,
        contentItem: NSMenuItem,
        onClickSettingsCallback: @escaping () -> Void
    ) {
        self.cpuThrottlingService = cpuThrottlingService
        self.analyticsService = analyticsService
        self.onClickSettingsCallback = onClickSettingsCallback
        statusBar = NSStatusBar.system
        statusItem = statusBar.statusItem(withLength: 80)

        super.init()

        let menu = NSMenu()
        menu.delegate = self
        menu.addItem(contentItem)
        menu.addItem(NSMenuItem.separator())
        let settingsItem = NSMenuItem(title: "Settings", action: #selector(onClickSettings), keyEquivalent: "")
        settingsItem.target = self
        menu.addItem(settingsItem)
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
                StatusBarController.logger.info("Updating status bar button title")
                statusBarButton.title = String(format: "CTM %3d%%", cpuThrottlingService.getCurrentSpeedLimit())
            }
        })

        Timer.scheduledTimer(withTimeInterval: 120, repeats: true, block: { _ in
            self.analyticsService.trackEvent(category: "track", action: "ping")
        })
    }

    @objc func onClickSettings() {
        StatusBarController.logger.info("Opening settings window")
        self.onClickSettingsCallback()
    }

    @objc func onQuit() {
        NSApp.terminate(self)
    }

    func menuWillOpen(_ menu: NSMenu) {
        analyticsService.trackEvent(category: "ui", action: "openMenu")
    }
}
