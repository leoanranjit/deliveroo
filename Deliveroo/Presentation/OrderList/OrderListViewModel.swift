//
//  OrderListViewModel.swift
//  DeliveryTrack
//
//  Created by Leoan Ranjit on 25/2/2026.
//

import Foundation
import Combine

@MainActor
final class OrderListViewModel: ObservableObject {

    @Published private(set) var state: OrderListState = .idle

    private let repository: OrderRepository

    init(repository: OrderRepository) {
        self.repository = repository
    }

    func load() async {
        state = .loading

        do {
            let orders = try await repository.fetchOrders()

            if orders.isEmpty {
                state = .empty
            } else {
                state = .loaded(orders)
            }

        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
