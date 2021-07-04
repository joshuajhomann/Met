//
//  Sequence+asyncUnorderedMap.swift
//  Met
//
//  Created by Joshua Homann on 7/4/21.
//

import Foundation

extension Sequence {
    func asyncUnorderedMap<Value>(awaiting transform: @escaping (Element) async throws -> Value) async rethrows -> [Value] {
        try await withThrowingTaskGroup(of: [Value].self) { group in
            forEach { element in
                group.async {
                    [try await transform(element)]
                }
            }
            return try await group.reduce(into: [Value]()) { total, next in
                total.append(contentsOf: next)
            }
        }
    }
}
