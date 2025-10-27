//
//  DataState.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 19/04/2019.
//  Copyright © 2019 Viable Labs. All rights reserved.
//

import Foundation

enum DataState<T: Equatable> {
    case initial
    case loading
    case data(T)
    case error(Error)
    case noData
}

extension DataState: Equatable {
    static func == (lhs: DataState, rhs: DataState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial):
            return true
        case (.loading, .loading):
            return true
        case (.data(let lhsData), .data(let rhsData)):
            return lhsData == rhsData
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.noData, .noData):
            return true
        default:
            return false
        }
    }
}
