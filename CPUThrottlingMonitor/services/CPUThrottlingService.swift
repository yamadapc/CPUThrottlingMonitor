//
//  CPUThrottlingService.swift
//  CPUThrottlingMonitor
//
//  Created by Pedro Tacla Yamada on 17/10/20.
//  Copyright © 2020 Pedro Tacla Yamada. All rights reserved.
//

import Foundation
import Cocoa
import Logging

protocol PMSetCommand {
    func runAndGetOutput() -> String?
}

class PMSetCommandImpl: PMSetCommand {
    func runAndGetOutput() -> String? {
        let task = Process()
        let pipe = Pipe()
        task.launchPath = "/usr/bin/pmset"
        task.arguments = ["-g", "therm"]
        task.standardOutput = pipe
        task.standardError = nil
        task.launch()
        task.waitUntilExit()
        let fileHandle = pipe.fileHandleForReading
        guard let outData = try? fileHandle.readToEnd() else { return nil }
        return String(decoding: outData, as: UTF8.self)
    }
}

class CPUThrottlingState: ObservableObject {
    @Published var speedLimits: [Int] = []
    var currentPosition = 0

    init() {}

    init(speedLimits: [Int]) {
        self.speedLimits = speedLimits
    }

    func getCurrentValue() -> Int {
        return speedLimits[currentPosition]
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
    private static let logger = Logger(label: "com.beijaflor.CPUThrottlingService")

    private let pmsetCommand: PMSetCommand
    var state = CPUThrottlingState()
    var maxPoints = 120

    init() {
        self.pmsetCommand = PMSetCommandImpl()
    }

    init(pmsetCommand: PMSetCommand) {
        self.pmsetCommand = pmsetCommand
    }

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
        CPUThrottlingService.logger.info("Refreshing CPU limit state")

        guard let outStr = pmsetCommand.runAndGetOutput() else { return }
        let speedLimit = outStr
            .split(separator: "\n")
            .first(where: { str in
                str.contains("CPU_Speed_Limit")
            })?.split(separator: "=")[1]
            .trimmingCharacters(in: CharacterSet.whitespaces)
        let speedLimitInt = Int(speedLimit ?? "100") ?? 100

        CPUThrottlingService.logger.info("Current CPU limit is \(speedLimitInt)")

        state.speedLimits[state.currentPosition] = speedLimitInt
        state.currentPosition += 1
        state.currentPosition %= maxPoints
    }
}
