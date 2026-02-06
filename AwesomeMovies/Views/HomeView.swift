//
//  HomeView.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 19-11-25.
//

import SwiftData
import SwiftUI

struct HomeView: View {
	@Environment(\.modelContext) var modelContext
	//ViewModel creation to handle UI data
	let viewModel = ViewModel()
	var heroTitle: Title {
		viewModel.heroTitle
	}
	@State private var titleDetailPath = NavigationPath()
	@Query var savedTitles: [Title]

	private var isLiked: Bool {
		savedTitles.contains(where: { $0.id == heroTitle.id })
	}

	var body: some View {
		// path saves all the screens you go through
		NavigationStack(path: $titleDetailPath) {
			//GeomtryReader get the available screen space or size and we can use it to define variables like the image below
			GeometryReader { geo in
				ScrollView(.vertical) {
					switch viewModel.homeStatus {
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
						LazyVStack {
							// This load the image in async form, and when it loads show a progress circle
							AsyncImage(
								url: URL(
									string: heroTitle.posterPath ?? ""
								)
							) { image in
								image
									.resizable()
									.scaledToFit()
									.overlay(
										LinearGradient(
											stops: [
												Gradient.Stop(
													color: .clear,
													location: 0.7
												),
												Gradient.Stop(
													color: .gradient,
													location: 1
												),
											],
											startPoint: .top,
											endPoint: .bottom
										)
									)
							} placeholder: {
								ProgressView()
							}
							.frame(
								width: geo.size.width,
								height: geo.size.height * 0.85
							)

							HStack {
								Button {
									// Here you put the button does
									titleDetailPath.append(heroTitle)
								} label: {
									//Here you put the button design
									Text(Constants.watchString)
										.primaryBtn()
								}

								Button {
									if isLiked {
										if let toRemove = savedTitles.first(where: {$0.id == heroTitle.id}){
											modelContext.delete(toRemove)
										}
									} else {
										let titleToSave = Title(
											id: heroTitle.id,
											title: heroTitle.title,
											overview: heroTitle.overview,
											posterPath: heroTitle.posterPath
										)
										modelContext.insert(titleToSave)
									}
									try? modelContext.save()
								} label: {
									LikedBtn(isLiked: isLiked)
								}
							}

							HorizontalListView(
								header: Constants.topRatedMoviesString,
								titles: viewModel.topRatedMovies,
								onSelect: { title in
									titleDetailPath.append(title)
								}
							)
							
							HorizontalListView(
								header: Constants.trendingMovieString,
								titles: viewModel.trendingMovies,
								onSelect: { title in
									titleDetailPath.append(title)
								}
							)

							HorizontalListView(
								header: Constants.topRatedTvString,
								titles: viewModel.topRatedTvShows,
								onSelect: { title in
									titleDetailPath.append(title)
								}
							)

							HorizontalListView(
								header: Constants.trendingTvShows,
								titles: viewModel.trendingTvShows,
								onSelect: { title in
									titleDetailPath.append(title)
								}
							)
						}

					case .failed(let error):
						Text(error.localizedDescription)
							.errorMsg()
					}
				}
				.task {
					await viewModel.getTitles()
				}
				// Here we can define the global route, we call it like titleDetailPath.append(title)
				.navigationDestination(for: Title.self) { title in
					TitlesDetailVew(title: title)
				}
			}
		}
	}
}

#Preview {
	HomeView()
}
