//
//  OrderStatus.swift
//  DeliveryTrack
//
//  Created by Leoan Ranjit on 25/2/2026.
//

import Foundation

enum OrderStatus: String, CaseIterable, Equatable {
    case pending = "PENDING"
    case inTransit = "IN_TRANSIT"
    case delivered = "DELIVERED"
}
