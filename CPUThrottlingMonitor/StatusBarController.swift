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
    private var popover: NSPopover?

    init(cpuThrottlingService: CPUThrottlingService, popover: NSPopover?) {
        self.cpuThrottlingService = cpuThrottlingService
        self.popover = popover
        statusBar = NSStatusBar()
        // Creating a status bar item having a fixed length
        statusItem = statusBar.statusItem(withLength: 80)

        if let statusBarButton = statusItem.button {
            statusBarButton.title = String(format: "therm %3d%%", cpuThrottlingService.getCurrentSpeedLimit())
            statusBarButton.action = #selector(togglePopover(sender:))
            statusBarButton.target = self
        }

        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
            if let statusBarButton = self.statusItem.button {
                statusBarButton.title = String(format: "therm %3d%%", cpuThrottlingService.getCurrentSpeedLimit())
            }
        })
    }

    @objc func togglePopover(sender: Any) {
        if ((popover?.isShown) == true) {
            popover?.performClose(sender)
        } else if let statusBarButton = statusItem.button {
            popover?.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
        }
    }
}
