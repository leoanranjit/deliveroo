//
//  OrderDetailsState.swift
//  DeliveryTrack
//
//  Created by Leoan Ranjit on 25/2/2026.
//

import Foundation

enum OrderDetailsState: Equatable {
    case loading
    case active(OrderStatus)
    case completed(OrderStatus)
}
