//
//  OrderDetailsViewModel.swift
//  DeliveryTrack
//
//  Created by Leoan Ranjit on 25/2/2026.
//

import Foundation
import Combine

@MainActor
final class OrderDetailsViewModel: ObservableObject {

    @Published private(set) var state: OrderDetailsState = .loading

    private let order: Order
    private let updater: OrderStatusUpdating

    init(order: Order, updater: OrderStatusUpdating) {
        self.order = order
        self.updater = updater
    }

    func start() {
        Task {
            for await status in updater.statusStream(for: order) {

                if status == .delivered {
                    state = .completed(status)
                } else {
                    state = .active(status)
                }
            }
        }
    }
}
