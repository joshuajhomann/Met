//
//  ContentView.swift
//  Met
//
//  Created by Joshua Homann on 6/25/21.
//

import Combine
import OrderedCollections
import SwiftUI

@MainActor
final class SearchViewModel: ObservableObject {
    @AppStorage("recents") var recentSearchTerms: String = ""
    @Published private(set) var recentSearches: OrderedSet<String> = []
    @Published private(set) var metObjects: [MetObject] = []
    private let searchService: MetSearchService
    private var fetchTaskHandle: Task.Handle<Void, Never>?
    init(searchService: MetSearchService = MetSearchService()) {
        self.searchService = searchService
        recentSearches = .init(recentSearchTerms.split(separator: "\u{12}").map(String.init(_:)))
    }
    deinit {
        fetchTaskHandle?.cancel()
    }
    func search(for term: String) {
        fetchTaskHandle?.cancel()
        fetchTaskHandle = detach { [searchService, weak self] in
            do {
                let result = try await searchService.search(for: term)
                let all = try await result.objectIDs.prefix(5).asyncUnorderedMap { id in
                    try await searchService.getObject(id: id)
                }
                DispatchQueue.main.async { [all, weak self] in
                    self?.update(metObjects: all, recentSearchTerm: term)
                }
            } catch {
                print(error)
            }
        }
    }
    private func update(metObjects: [MetObject], recentSearchTerm: String) {
        self.metObjects = metObjects
        recentSearches.append(recentSearchTerm)
        recentSearchTerms = recentSearches.joined(separator: "\u{12}")
    }
}

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                List(viewModel.metObjects) { row in
                    NavigationLink(destination: {
                        DetailView(viewModel: .init(object: row))
                    }, label: {
                        VStack(alignment: .leading) {
                            AsyncImage(
                                url: URL(string: row.primaryImage),
                                content: { image in image.resizable() },
                                placeholder: { Color.gray }
                            )
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: proxy.size.width, maxHeight: proxy.size.width)
                            Text(row.title)
                                .font(.title)
                            Text(row.department)
                                .font(.body)
                            Text(row.objectDate)
                                .font(.body)
                        }
                    })
                        .listRowSeparator(.hidden)
                }
                .listStyle(.grouped)
                .navigationTitle("Search")
            }
        }
        .searchable(text: $searchText) {
            ForEach(viewModel.recentSearches.reversed(), id: \.self) { search in
                Text(search)
                    .searchCompletion(search)
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
