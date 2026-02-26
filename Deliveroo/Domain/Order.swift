//
//  Order.swift
//  DeliveryTrack
//
//  Created by Leoan Ranjit on 25/2/2026.
//

import Foundation

struct Order: Identifiable, Equatable {
    let id: UUID
    let title: String
    let status: OrderStatus
}
