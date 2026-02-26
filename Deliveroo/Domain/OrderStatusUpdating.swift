//
//  OrderStatusUpdating.swift
//  DeliveryTrack
//
//  Created by Leoan Ranjit on 25/2/2026.
//

import Foundation

protocol OrderStatusUpdating {
    func statusStream(for order: Order) -> AsyncStream<OrderStatus>
}
