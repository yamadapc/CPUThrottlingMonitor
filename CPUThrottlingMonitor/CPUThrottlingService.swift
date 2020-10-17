//
//  CPUThrottlingService.swift
//  CPUThrottlingMonitor
//
//  Created by Pedro Tacla Yamada on 17/10/20.
//  Copyright © 2020 Pedro Tacla Yamada. All rights reserved.
//

import Foundation
import Cocoa

class CPUThrottlingState: ObservableObject {
    @Published var speedLimits: [Int] = []
    var currentPosition = 0

    init() {}

    init(speedLimits: [Int]) {
        self.speedLimits = speedLimits
    }

    func getHistory() -> [Int] {
        var history: [Int] = []
        if speedLimits.count == 0 {
            return []
        }
        for i in 0...speedLimits.count-1 {
            let index = (currentPosition + i) % speedLimits.count
            let value = speedLimits[index]
            history.append(value)
        }
        return history
    }
}

class CPUThrottlingService {
    var state = CPUThrottlingState()
    var maxPoints = 120

    func start() {
        for _ in 0...maxPoints-1 {
            state.speedLimits.append(100)
        }
        run()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
            self.run()
        })
    }

    func getCurrentSpeedLimit() -> Int {
        let indexCandidate = (state.currentPosition - 1) % maxPoints
        let index = indexCandidate >= 0 ? indexCandidate : maxPoints + indexCandidate
        return state.speedLimits[index]
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

            state.speedLimits[state.currentPosition] = speedLimitInt
            state.currentPosition += 1
            state.currentPosition %= maxPoints
        }
    }
}
