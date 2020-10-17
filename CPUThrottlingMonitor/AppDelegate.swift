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
    var popover: NSPopover!
    var statusBarController: StatusBarController!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        cpuThrottlingService = CPUThrottlingService()
        cpuThrottlingService.start()

        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(state: cpuThrottlingService.state)

        popover = NSPopover()
        popover.contentSize = NSSize(width: 360, height: 200)
        popover.contentViewController = NSHostingController(rootView: contentView)

        statusBarController = StatusBarController(
            cpuThrottlingService: cpuThrottlingService,
            popover: popover
        )
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

