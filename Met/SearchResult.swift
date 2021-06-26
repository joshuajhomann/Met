//
//  SearchResult.swift
//  Met
//
//  Created by Joshua Homann on 6/26/21.
//

import Foundation

// MARK: - SearchResult
struct SearchResult: Codable {
    var total: Int
    var objectIDs: [Int]
}
