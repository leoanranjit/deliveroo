//
//  OrderDetailsView.swift
//  DeliveryTrack
//
//  Created by Leoan Ranjit on 25/2/2026.
//

import SwiftUI

struct OrderDetailsView: View {

    @StateObject private var viewModel: OrderDetailsViewModel

    init(viewModel: OrderDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        content
            .navigationTitle("Order Details")
            .task {
                viewModel.start()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {

        case .loading:
            ProgressView("Tracking Order...")

        case .active(let status):
            VStack(spacing: 16) {
                Text("Current Status")
                    .font(.headline)

                Text(status.rawValue)
                    .font(.title)
                    .foregroundStyle(.blue)
            }

        case .completed(let status):
            VStack(spacing: 16) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.green)

                Text(status.rawValue)
                    .font(.title)
            }
        }
    }
}
