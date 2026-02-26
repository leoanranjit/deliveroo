//
//  DeliverooApp.swift
//  Deliveroo
//
//  Created by Leoan Ranjit on 26/2/2026.
//

import SwiftUI

@main
struct DeliverooApp: App {
    var body: some Scene {
        WindowGroup {
            OrderListView(
                viewModel: OrderListViewModel(
                    repository: previewRepository
                )
            )
        }
    }

    private var previewRepository: OrderRepository {
        MockOrderRepository(
            behavior: .delayedSuccess(
                [
                    Order(id: UUID(), title: "Order #1", status: .pending),
                    Order(id: UUID(), title: "Order #2", status: .inTransit),
                    Order(id: UUID(), title: "Order #3", status: .delivered)
                ],
                delay: 2.0
            )
        )
    }
}
