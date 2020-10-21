//
//  AppDelegate.swift
//  CPUThrottlingMonitor
//
//  Created by Pedro Tacla Yamada on 17/10/20.
//  Copyright © 2020 Pedro Tacla Yamada. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private var cpuThrottlingService: CPUThrottlingService!
    private var analyticsService: AnalyticsService!
    private var analyticsSettingsAlertController: AnalyticsSettingsAlertController!
    private var statusBarController: StatusBarController!
    private var settingsWindowController: SettingsWindowController!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        cpuThrottlingService = CPUThrottlingService()
        analyticsService = AnalyticsService(options: getAnalyticsOptions())
        analyticsSettingsAlertController = AnalyticsSettingsAlertController(analyticsService: analyticsService)

        cpuThrottlingService.start()
        analyticsService.trackEvent(category: "track", action: "startup")

        settingsWindowController = SettingsWindowController(analyticsService: analyticsService)

        statusBarController = StatusBarController(
            cpuThrottlingService: cpuThrottlingService,
            analyticsService: analyticsService,
            contentItem: LineChartMenuItem(cpuThrottlingState: cpuThrottlingService.state),
            onClickSettingsCallback: { self.settingsWindowController.onClickSettings() }
        )

        analyticsSettingsAlertController.applicationDidFinishLaunching()

        NSApp.setActivationPolicy(.accessory)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

    private func getAnalyticsOptions() -> AnalyticsServiceOptions {
        return AnalyticsServiceOptions(
            trackingId: "UA-74188650-7",
            clientId: abs(UUID().hashValue % 1000).description
        )
    }
}

