//
//  OrderListView.swift
//  DeliveryTrack
//
//  Created by Leoan Ranjit on 25/2/2026.
//

import SwiftUI

struct OrderListView: View {

    @StateObject private var viewModel: OrderListViewModel
    @State private var selectedFilter: OrderStatus? = nil

    init(viewModel: OrderListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Orders")
                .task {
                    await viewModel.load()
                }
        }
    }
    
    private var filterBar: some View {
        Picker("Filter", selection: $selectedFilter) {
            Text("All").tag(OrderStatus?.none)

            ForEach(OrderStatus.allCases, id: \.self) { status in
                Text(status.rawValue)
                    .tag(Optional(status))
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {

        case .idle, .loading:
            ProgressView("Loading Orders...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .empty:
            VStack(spacing: 12) {
                Image(systemName: "tray")
                    .font(.largeTitle)
                Text("No orders available")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .error(let message):
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)

                Text("Something went wrong")
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Button("Retry") {
                    Task { await viewModel.load() }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded(let orders):
            VStack {
                filterBar
                orderList(filtered(orders))
            }
        }
    }
    
    private func filtered(_ orders: [Order]) -> [Order] {
        guard let selectedFilter else {
            return orders
        }

        return orders.filter { $0.status == selectedFilter }
    }
    
    private func orderList(_ orders: [Order]) -> some View {
        List(orders) { order in
            NavigationLink {
                OrderDetailsView(
                    viewModel: OrderDetailsViewModel(
                        order: order,
                        updater: MockOrderStatusUpdater()
                    )
                )
            } label: {
                VStack(alignment: .leading) {
                    Text(order.title)
                        .font(.headline)

                    Text(order.status.rawValue)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
