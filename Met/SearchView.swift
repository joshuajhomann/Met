//
//  ContentView.swift
//  Met
//
//  Created by Joshua Homann on 6/25/21.
//

import Combine
import SwiftUI

@MainActor
final class SearchViewModel: ObservableObject {
    @AppStorage("recents") var recentSearchTerms: String = ""
    @Published private(set) var recentSearches: [String] = []
    @Published private(set) var metObjects: [MetObject] = []
    private let searchService: MetSearchService
    init(searchService: MetSearchService = MetSearchService()) {
        self.searchService = searchService
        recentSearches = recentSearchTerms.split(separator: "\u{12}").map(String.init(_:))
    }
    func search(for term: String) {
        async { [searchService, weak self] in
            do {
                let result = try await searchService.search(for: term)
                var all: [MetObject] = []
                for id in result.objectIDs.prefix(5) {
                    all.append(try await searchService.getObject(id: id) )
                }
                self?.metObjects = all
                self?.recentSearches.append(term)
                self?.recentSearchTerms = (self?.recentSearches ?? []).joined(separator: "\u{12}")
            } catch {
                print(error)
            }
        }
    }
}

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                List(viewModel.metObjects) { row in
                    VStack(alignment: .leading) {
                        AsyncImage(
                            url: URL(string: row.primaryImageSmall),
                            content: { image in
                            image.resizable()
                        },
                            placeholder: { Color.gray }
                        )
                            .frame(maxWidth: proxy.size.width)
                            .aspectRatio(1, contentMode: .fit)
                        Text(row.title)
                            .font(.title)
                        Text(row.department)
                            .font(.body)
                        Text(row.objectDate)
                            .font(.body)
                    }
                }
                .navigationTitle("Search")
            }
        }
        .searchable(text: $searchText) {
            ForEach(0..<viewModel.recentSearches.count) {
                Text(viewModel.recentSearches[$0])
                    .searchCompletion(viewModel.recentSearches[$0])
            }
        }
        .onSubmit(of: .search) { viewModel.search(for: searchText) }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
