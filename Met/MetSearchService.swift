//
//  MetSearchService.swift
//  Met
//
//  Created by Joshua Homann on 6/26/21.
//

import Foundation

actor MetSearchService {
    enum Error: Swift.Error {
        case invalidURL
    }
    private enum Constant {
        static let host = "collectionapi.metmuseum.org"
        static let getObjectPath = "/public/collection/v1/objects/"
        static let searchPath = "/public/collection/v1/search"
    }
    func search(for term: String) async throws -> SearchResult {
        try await getValue(
            of: SearchResult.self,
            from: Constant.searchPath,
            parameters: [.init(name: "q", value: term)]
        )
    }
    func getObject(id: Int) async throws -> MetObject {
        try await getValue(
            of: MetObject.self,
            from: "\(Constant.getObjectPath)\(id)"
        )
    }

    private func getValue<SomeCodable: Codable>(
        of type: SomeCodable.Type,
        from path: String,
        parameters: [URLQueryItem]? = nil
    ) async throws -> SomeCodable {
        var components = URLComponents()
        components.host = Constant.host
        components.scheme = "https"
        components.path = path
        components.queryItems = parameters
        guard let url = components.url else {
            throw Error.invalidURL
        }
        print(url)
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        let decoder = JSONDecoder()
        let value = try decoder.decode(SomeCodable.self, from: data)
        print(value)
        return value
    }
}
