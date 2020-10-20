//
//  CircularBuffer.swift
//  CPUThrottlingMonitor
//
//  Created by Pedro Tacla Yamada on 21/10/20.
//  Copyright © 2020 Pedro Tacla Yamada. All rights reserved.
//

import Foundation

public class CircularBuffer<T>: ObservableObject, Sequence {
    public typealias Element = T
    public typealias Iterator = CircularBufferIterator<T>

    public var underestimatedCount: Int {
        get { return maxSize }
    }

    @Published private var maxSize: Int
    @Published private var position: Int = 0
    @Published private var buffer: [T] = []

    public init(maxSize: Int, initialValue: T) {
        self.maxSize = maxSize
        for _ in 0..<self.maxSize {
            buffer.append(initialValue)
        }
    }

    public subscript(index: Int) -> T {
        return get(index)
    }

    public __consuming func makeIterator() -> CircularBufferIterator<T> {
        return CircularBufferIterator(parent: self)
    }

    public func head() -> T {
        let index = position - 1
        if index < 0 {
            return buffer[maxSize + index]
        } else {
            return buffer[index]
        }
    }

    public func append(_ value: T) {
        buffer[position] = value
        position += 1
        position %= maxSize
    }

    public func get(_ i: Int) -> T {
        let index = (position + i) % maxSize
        return buffer[index]
    }

    public func size() -> Int {
        return maxSize
    }

    public struct CircularBufferIterator<T>: IteratorProtocol {
        public typealias Element = T

        private let parent: CircularBuffer<T>
        private var pos: Int

        init(parent: CircularBuffer<T>) {
            self.parent = parent
            self.pos = 0
        }

        public mutating func next() -> T? {
            if pos >= parent.size() {
                return nil
            }

            let value = parent.get(pos)
            pos += 1
            return value
        }
    }
}
