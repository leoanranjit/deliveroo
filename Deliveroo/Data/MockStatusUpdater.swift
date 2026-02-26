//
//  MockStatusUpdater.swift
//  DeliveryTrack
//
//  Created by Leoan Ranjit on 25/2/2026.
//

import Foundation

final class MockOrderStatusUpdater: OrderStatusUpdating {

    private let delay: TimeInterval

    init(delay: TimeInterval = 2.0) {
        self.delay = delay
    }

    func statusStream(for order: Order) -> AsyncStream<OrderStatus> {
        AsyncStream { continuation in
            Task {
                continuation.yield(.pending)

                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                continuation.yield(.inTransit)

                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                continuation.yield(.delivered)

                continuation.finish()
            }
        }
    }
}
