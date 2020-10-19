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
    var popover: NSMenu!
    var statusBarController: StatusBarController!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        cpuThrottlingService = CPUThrottlingService()
        cpuThrottlingService.start()

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
            contentItem: menuItem
        )
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

