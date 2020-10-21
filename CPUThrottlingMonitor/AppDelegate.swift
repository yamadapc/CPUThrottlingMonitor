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
    var cpuThrottlingService: CPUThrottlingService!
    var analyticsService: AnalyticsService!
    var popover: NSMenu!
    var statusBarController: StatusBarController!
    var settingsWindow: NSWindow? = nil

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        cpuThrottlingService = CPUThrottlingService()
        cpuThrottlingService.start()

        analyticsService = AnalyticsService(
            options: AnalyticsServiceOptions(
                trackingId: "UA-74188650-7",
                clientId: abs(UUID().hashValue % 1000).description
            )
        )
        analyticsService.trackEvent(category: "track", action: "startup")

        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(state: cpuThrottlingService.state)

        let menuItem = NSMenuItem(title: "Custom", action: nil, keyEquivalent: "")
        let hostingView = NSHostingView(rootView: contentView)
        hostingView.frame = NSRect(
            origin: CGPoint(),
            size: CGSize(width: 250.0, height: 100.0)
        )
        menuItem.isEnabled = true
        menuItem.view = hostingView

        statusBarController = StatusBarController(
            cpuThrottlingService: cpuThrottlingService,
            analyticsService: analyticsService,
            contentItem: menuItem,
            onClickSettingsCallback: {
                self.analyticsService.trackView(page: "/settings", title: "SettingsPage")
                self.onClickSettings()
            }
        )

        if UserDefaults.standard.value(forKey: "disableAnalytics") == nil {
            let alert = NSAlert()
            alert.messageText = "Enable analytics?"
            alert.informativeText = "Whether to send anonymous usage statistics to help us make this better. You can change this later."
            alert.addButton(withTitle: "Yes")
            alert.addButton(withTitle: "No")
            let response = alert.runModal()
            if response == .OK {
                UserDefaults.standard.setValue(false, forKey: "disableAnalytics")
            } else {
                UserDefaults.standard.setValue(true, forKey: "disableAnalytics")
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

    func onClickSettings() {
        if let w = settingsWindow {
            w.makeKeyAndOrderFront(self)
            return
        }

        let settingsView = SettingsView()
        let hostingView = NSHostingView(rootView: settingsView)
        let contentRect = NSRect(origin: CGPoint(), size: CGSize(width: 200.0, height: 100.0))
        let window = NSWindow(
            contentRect: contentRect,
            styleMask: [.resizable, .titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        hostingView.frame = contentRect
        window.contentView = hostingView
        window.isReleasedWhenClosed = false
        window.center()
        window.makeKeyAndOrderFront(self)

        settingsWindow = window

        window.orderFrontRegardless()
    }
}

