//
//  SearchView.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 02-01-26.
//

import SwiftUI

struct SearchView: View {

    //var titles = Title.previewTitles
    @State private var searchByMovie = true
    @State private var searchString = ""
    private var searchViewModel = SearchViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                    ForEach(searchViewModel.searchTitles) { title in
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
                        
                        Task {
                            await searchViewModel.getSearchTitles(
                                by: searchByMovie ? "movie" : "tv", for: searchString)
                        }
                        
                    } label: {
                        Image(
                            systemName: searchByMovie
                                ? Constants.movieIconString
                                : Constants.tvIconString)
                    }
                }
            }.searchable(
                text: $searchString,
                prompt: searchByMovie
                    ? Constants.movieSearchPlaceholderString
                    : Constants.tvSearchPlaceholderString
            )
            .task(id: searchString) {
                try? await Task.sleep(for: .milliseconds(2000))
                print("Searching....")

                if Task.isCancelled {
                    print("Task is cancelled...")
                    return
                }

                await searchViewModel.getSearchTitles(
                    by: searchByMovie ? "movie" : "tv", for: searchString)
            }
        }
    }
}

#Preview {
    SearchView()
}
