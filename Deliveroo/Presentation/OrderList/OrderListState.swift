//
//  OrderListState.swift
//  DeliveryTrack
//
//  Created by Leoan Ranjit on 25/2/2026.
//

import Foundation

enum OrderListState: Equatable {
    case idle
    case loading
    case loaded([Order])
    case empty
    case error(String)
}
