//
//  OrderRepository.swift
//  DeliveryTrack
//
//  Created by Leoan Ranjit on 25/2/2026.
//

import Foundation

protocol OrderRepository {
    func fetchOrders() async throws -> [Order]
}
