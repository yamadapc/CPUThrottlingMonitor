//
//  SettingsWindowController.swift
//  CPUThrottlingMonitor
//
//  Created by Pedro Tacla Yamada on 22/10/20.
//  Copyright © 2020 Pedro Tacla Yamada. All rights reserved.
//

import SwiftUI
import Cocoa

class SettingsWindowController: NSWindowController {
    private var analyticsService: AnalyticsService!

    init(analyticsService: AnalyticsService) {
        self.analyticsService = analyticsService

        let window = SettingsWindowController.makeWindow(analyticsService)
        super.init(window: window)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func onClickSettings() {
        self.analyticsService.trackView(page: "/settings", title: "SettingsPage")

        self.window = SettingsWindowController.makeWindow(analyticsService)
        guard let window = self.window else { return }
        window.center()
        window.makeKeyAndOrderFront(self)
        window.orderFrontRegardless()
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    }

    private static func makeWindow(_ analyticsService: AnalyticsService) -> NSWindow {
        let settingsView = SettingsView(analyticsService: analyticsService)
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
        window.isReleasedWhenClosed = true
        return window
    }
}
