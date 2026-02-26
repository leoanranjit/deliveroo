//
//  MockOrderRepository.swift
//  DeliveryTrack
//
//  Created by Leoan Ranjit on 25/2/2026.
//

import Foundation

final class MockOrderRepository: OrderRepository {

    enum Behavior {
        case success([Order])
        case failure(Error)
        case delayedSuccess([Order], delay: TimeInterval)
        case delayedFailure(Error, delay: TimeInterval)
    }

    private let behavior: Behavior

    init(behavior: Behavior) {
        self.behavior = behavior
    }

    func fetchOrders() async throws -> [Order] {
        switch behavior {

        case .success(let orders):
            return orders

        case .failure(let error):
            throw error

        case .delayedSuccess(let orders, let delay):
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            return orders

        case .delayedFailure(let error, let delay):
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            throw error
        }
    }
}
