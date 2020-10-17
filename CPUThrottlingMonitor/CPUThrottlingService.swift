//
//  CPUThrottlingService.swift
//  CPUThrottlingMonitor
//
//  Created by Pedro Tacla Yamada on 17/10/20.
//  Copyright © 2020 Pedro Tacla Yamada. All rights reserved.
//

import Foundation
import Cocoa

class CPUThrottlingService {
    var speedLimits: [Int] = []
    var currentPosition = 0
    var maxPoints = 120 // runs every 5s shows 10min

    func start() {
        for _ in 0...maxPoints {
            speedLimits.append(0)
        }
        run()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
            self.run()
        })
    }

    func getCurrentSpeedLimit() -> Int {
        let indexCandidate = (currentPosition - 1) % maxPoints
        let index = indexCandidate >= 0 ? indexCandidate : maxPoints + indexCandidate
        return speedLimits[index]
    }

    func getHistory() -> [Int] {
        var history: [Int] = []
        for i in 0...maxPoints {
            let index = (currentPosition + i) % maxPoints
            let value = speedLimits[index]
            history.append(value)
        }
        return history
    }

    func run() {
        // print("Refreshing therm status")
        let task = Process()
        let pipe = Pipe()
        task.launchPath = "/usr/bin/pmset"
        task.arguments = ["-g", "therm"]
        task.standardOutput = pipe
        task.standardError = nil
        task.launch()
        task.waitUntilExit()
        let fileHandle = pipe.fileHandleForReading
        if let outData = try? fileHandle.readToEnd() {
            let outStr = String(decoding: outData, as: UTF8.self)
            let speedLimit = outStr
                .split(separator: "\n")
                .first(where: { str in
                    str.contains("CPU_Speed_Limit")
                })?.split(separator: "=")[1]
                .trimmingCharacters(in: CharacterSet.whitespaces)
            let speedLimitInt = Int(speedLimit ?? "100") ?? 100

            speedLimits[currentPosition] = speedLimitInt
            currentPosition += 1
            currentPosition %= maxPoints
        }
    }
}
