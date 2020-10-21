//
//  AnalyticsSettingsAlertController.swift
//  CPUThrottlingMonitor
//
//  Created by Pedro Tacla Yamada on 22/10/20.
//  Copyright © 2020 Pedro Tacla Yamada. All rights reserved.
//

import Cocoa
import Foundation

class AnalyticsSettingsAlertController {
    private let analyticsService: AnalyticsService

    init(
        analyticsService: AnalyticsService
    ) {
        self.analyticsService = analyticsService
    }

    func applicationDidFinishLaunching() {
        if !analyticsService.hasSetIsEnabledBefore() {
            let alert = NSAlert()
            alert.messageText = "Enable analytics?"
            alert.informativeText = "Whether to send anonymous usage statistics to help us make this better. You can change this later."
            alert.addButton(withTitle: "Yes")
            alert.addButton(withTitle: "No")
            let response = alert.runModal()
            if response == .alertFirstButtonReturn {
                analyticsService.setIsEnabled(true)
            } else {
                analyticsService.setIsEnabled(false)
            }
        }
    }
}
