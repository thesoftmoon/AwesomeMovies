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
	@State private var navigationPath = NavigationPath()
	private var searchViewModel = SearchViewModel()

	var body: some View {
		NavigationStack(path: $navigationPath) {
			GeometryReader { geo in
				ScrollView {

					switch searchViewModel.searchFetchStatus {
					case .notStarted:
						EmptyView()
					case .fetching:
						ProgressView()
							// With this geo sizing, we center the elements in the available screen
							.frame(
								width: geo.size.width,
								height: geo.size.height
							)
					case .success:
						titlesGrid(geometry: geo)
					case .failed(_):
						errorMessage(geometry: geo)
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
								by: searchByMovie ? "movie" : "tv",
								for: searchString
							)
						}

					} label: {
						Image(
							systemName: searchByMovie
								? Constants.movieIconString
								: Constants.tvIconString
						)
					}
				}
			}.searchable(
				text: $searchString,
				prompt: searchByMovie
					? Constants.movieSearchPlaceholderString
					: Constants.tvSearchPlaceholderString
			)
			.task(id: searchString) {
				try? await Task.sleep(for: .milliseconds(500))
				print("Searching....")

				if Task.isCancelled {
					print("Task is cancelled...")
					return
				}

				await searchViewModel.getSearchTitles(
					by: searchByMovie ? "movie" : "tv",
					for: searchString
				)
			}
			.navigationDestination(for: Title.self) { title in
				TitlesDetailVew(title: title)
			}
		}
	}

	@ViewBuilder
	private func titlesGrid(geometry: GeometryProxy) -> some View {
		LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
			ForEach(searchViewModel.searchTitles) { title in
				titleCell(for: title)
			}
		}
	}

	@ViewBuilder
	private func titleCell(for title: Title) -> some View {
		Group {
			if let url = URL(string: title.posterPath ?? "") {

				AsyncImage(url: url) { phase in
					if let image = phase.image {
						image
							.resizable()
							.scaledToFit()
							.clipShape(.rect(cornerRadius: 15))
					} else {
						ProgressView()
					}
				}
			} else {
				VStack {
					Image(systemName: "photo.fill")
						.resizable()
						.scaledToFit()
						.padding(10)
						.foregroundColor(.gray)
					Text(title.title ?? "Sin titulo")
						.bold()
						.font(.system(size: 10))
						.multilineTextAlignment(.center)
				}
				.padding(10)
			}
		}
		.frame(width: 120, height: 200)
		.onTapGesture {
			navigationPath.append(title)
		}
	}

	@ViewBuilder
	private func errorMessage(geometry: GeometryProxy)
		-> some View
	{
		if let error = searchViewModel.errorMessage {
			Text(error)
				.errorMsg()

		}
	}
}

#Preview {
	SearchView()
}
