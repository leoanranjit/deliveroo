//
//  OrderListViewModelTest.swift
//  DeliveryTrack
//
//  Created by Leoan Ranjit on 25/2/2026.
//

import XCTest
@testable import Deliveroo

@MainActor
final class OrderListViewModelTests: XCTestCase {

    func test_load_success_setsLoadedState() async {
        let order = Order(
            id: UUID(),
            title: "Test Order",
            status: .pending
        )

        let repository = MockOrderRepository(
            behavior: .success([order])
        )

        let viewModel = OrderListViewModel(repository: repository)

        await viewModel.load()

        XCTAssertEqual(viewModel.state, .loaded([order]))
    }

    func test_load_empty_setsEmptyState() async {
        let repository = MockOrderRepository(
            behavior: .success([])
        )

        let viewModel = OrderListViewModel(repository: repository)

        await viewModel.load()

        XCTAssertEqual(viewModel.state, .empty)
    }

    func test_load_failure_setsErrorState() async {
        struct SampleError: Error {}

        let repository = MockOrderRepository(
            behavior: .failure(SampleError())
        )

        let viewModel = OrderListViewModel(repository: repository)

        await viewModel.load()

        if case .error = viewModel.state {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected error state")
        }
    }
}

