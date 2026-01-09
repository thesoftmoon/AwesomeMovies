//
//  SearchView.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 02-01-26.
//

import SwiftUI

struct SearchView: View {

    var titles = Title.previewTitles
    @State private var searchByMovie = true

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                    ForEach(titles) { title in
                        AsyncImage(url: URL(string: title.posterPath ?? "")) {
                            image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(.rect(cornerRadius: 15))
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 120, height: 200)
                    }
                }
            }
            .navigationTitle(
                searchByMovie
                    ? Constants.movieSearchString : Constants.tvSearchString
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        searchByMovie.toggle()
                    } label: {
                        Image(
                            systemName: searchByMovie
                                ? Constants.movieIconString
                                : Constants.tvIconString)
                    }
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
