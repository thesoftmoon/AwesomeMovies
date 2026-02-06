//
//  UpcomingView.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 27-12-25.
//

import SwiftUI

struct UpcomingView: View {
	let viewModel = ViewModel()
	@State private var titleDetailPath = NavigationPath()
	let headerTitle = Constants.upcomingMoviesString

	var body: some View {
		NavigationStack(path: $titleDetailPath) {
			GeometryReader { geo in
				switch viewModel.upcomingMoviesStatus {
				case .notStarted:
					EmptyView()
				case .fetching:
					ProgressView()
						.frame(width: geo.size.width, height: geo.size.height)
				case .success:
					VerticalListView(
						titles: viewModel.upcomingMovies,
						onSelect: { title in
							titleDetailPath.append(title)
						}
					)
				case .failed(let error):
					Text(error.localizedDescription)
						.errorMsg()
				}
			}.task {
				await viewModel.getUpcomingMovies()
			}
			.navigationDestination(for: Title.self) { title in
				TitlesDetailVew(title: title)
			}
			.toolbar {
				ToolbarItem(placement: .principal) {
					Text(headerTitle)
						.font(.system(size: 24))
						.bold()
				}
			}
		}

	}
}

#Preview {
	UpcomingView()
}
