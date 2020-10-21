//
//  AnalyticsService.swift
//  CPUThrottlingMonitor
//
//  Created by Pedro Tacla Yamada on 20/10/20.
//  Copyright © 2020 Pedro Tacla Yamada. All rights reserved.
//

import Foundation
import Alamofire
import Logging

struct AnalyticsServiceOptions {
    let trackingId: String
    let clientId: String
}

class AnalyticsService {
    private static let logger = Logger(label: "com.beijaflor.AnalyticsService")
    private let options: AnalyticsServiceOptions

    init(options: AnalyticsServiceOptions) {
        self.options = options
        AnalyticsService.logger.info("Loaded: analyticsEnabled=\(getIsEnabled())")
    }

    func trackView(page: String, title: String) {
        if !getIsEnabled() {
            return
        }
        AnalyticsService.logger.info("Publishing analytics page=\(page) title=\(title)")

        let parameters = [
            "v": "1",
            "tid": self.options.trackingId,
            "cid": self.options.clientId,
            "t": "pageview",
            "dh": "cpumonitor.beijaflor.io",
            "dp": page,
            "dt": title,
        ]
        Alamofire.AF.request(
            buildUrl(),
            method: .post,
            parameters: parameters,
            headers: [
                "Host": "www.google-analytics.com",
                "Accept": "*/*",
                "User-Agent": "beijaflor:1.0",
            ]
        ).response { response in
            AnalyticsService.logger.debug("Published analytics and got response \(response.debugDescription)")
        }
    }

    func trackEvent(category: String, action: String, label: String? = nil, value: String? = nil) {
        if !getIsEnabled() {
            return
        }
        AnalyticsService.logger.info("Publishing analytics category=\(category) action=\(action)")

        var parameters: [String:String] = [
            "v": "1",
            "tid": self.options.trackingId,
            "cid": self.options.clientId,
            "t": "event",
            "ec": category,
            "ea": action,
            "el": label ?? action
        ]
        if let v = value {
            parameters["ev"] = v
        }
        let request = Alamofire.AF.request(
            buildUrl(),
            method: .post,
            parameters: parameters,
            headers: HTTPHeaders([
                "Host": "www.google-analytics.com",
                "Accept": "*/*",
                "User-Agent": "beijaflor:1.0",
            ])
        )
        request.response { response in
            AnalyticsService.logger.debug("Request: \(parameters) \(String(describing: response.request?.debugDescription))")
            AnalyticsService.logger.debug("Published analytics and got response \(response.debugDescription)")
            AnalyticsService.logger.debug("Response body \(String(describing: String(data: response.data ?? Data(), encoding: .utf8)))")
        }
    }

    func getIsEnabled() -> Bool {
        return !UserDefaults.standard.bool(forKey: "disableAnalytics")
    }

    func setIsEnabled(_ enabled: Bool) {
        AnalyticsService.logger.info("Setting analytics settings enabled=\(enabled)")
        UserDefaults.standard.setValue(!enabled, forKey: "disableAnalytics")
    }

    func hasSetIsEnabledBefore() -> Bool {
        return UserDefaults.standard.value(forKey: "disableAnalytics") != nil
    }

    private func buildUrl() -> String {
        return "https://www.google-analytics.com/collect"
    }
}
