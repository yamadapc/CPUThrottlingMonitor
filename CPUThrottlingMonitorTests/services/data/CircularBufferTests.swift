//
//  CircularBufferTests.swift
//  CPUThrottlingMonitorTests
//
//  Created by Pedro Tacla Yamada on 21/10/20.
//  Copyright © 2020 Pedro Tacla Yamada. All rights reserved.
//

import Foundation
import XCTest

import CPUThrottlingMonitor

class CircularBufferTests: XCTestCase {
    func testInit() {
        let buffer = CircularBuffer(maxSize: 10, initialValue: 0.0)
        XCTAssertEqual(buffer.size(), 10)
        var calledOnce = false
        for i in buffer {
            XCTAssertEqual(i, 0.0)
            calledOnce = true
        }
        XCTAssertEqual(calledOnce, true)
    }

    func testAppend_addsItemsToHead() {
        let buffer = CircularBuffer(maxSize: 10, initialValue: 0.0)
        buffer.append(2.0)
        XCTAssertEqual(buffer.head(), 2.0)
    }

    func testAppend_goesBackToTheStartOnEnd() {
        // buffer can fit 2
        let buffer = CircularBuffer(maxSize: 2, initialValue: 0.0)
        // initial state
        buffer.append(1.0)
        buffer.append(2.0)
        XCTAssertEqual(buffer.get(0), 1.0)
        XCTAssertEqual(buffer.get(1), 2.0)
        // append one more
        buffer.append(3.0)
        XCTAssertEqual(buffer.get(0), 2.0)
        XCTAssertEqual(buffer.get(1), 3.0)
    }
}
