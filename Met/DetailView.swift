//
//  DetailView.swift
//  Met
//
//  Created by Joshua Homann on 7/3/21.
//

import SwiftUI

struct DetailViewModel {
    var title: String
    var imageURLs: [URL]
    var constituents: AttributedString
    var metadataDate: String
    var measurements: String
    init(object: MetObject) {
        imageURLs = ([object.primaryImage] + object.additionalImages)
            .compactMap(URL.init(string:))
        title = object.title
        constituents = object.constituents?.first.flatMap { constituent in
            try? AttributedString(markdown: " **\(constituent.role)**: \(constituent.name)")
        } ?? .init()
        let date = try? Date(
            object.metadataDate,
            strategy: .iso8601.year().month().day().dateSeparator(.dash).timeSeparator(.colon).time(includingFractionalSeconds: true)
        )
        metadataDate = date?.formatted(date: .long, time: .omitted) ?? ""

        measurements = object.dimensions
            .split(separator: ";")
            .map(String.init(_:))
            .formatted()
    }
}

struct DetailView: View {
    var viewModel: DetailViewModel
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                ForEach(viewModel.imageURLs, id: \.self) { url in
                    AsyncImage(
                        url: url,
                        content: { image in image.resizable() },
                        placeholder: { Color.gray }
                    )
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: proxy.size.width, maxHeight: proxy.size.width)
                }
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    VStack (alignment: .leading){
                        Text(viewModel.title)
                            .font(.title)
                        Text(viewModel.metadataDate)
                            .foregroundStyle(.secondary)
                        Text(viewModel.constituents)
                            .foregroundStyle(.tertiary)
                        Text(viewModel.measurements)
                            .foregroundStyle(.quaternary)

                    }
                    Spacer()
                }
                .padding()
                .background(Material.regular)
            }
        }
        .navigationTitle(viewModel.title)
    }
}
