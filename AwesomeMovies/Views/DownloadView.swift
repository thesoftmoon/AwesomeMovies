//
//  DownloadView.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 29-01-26.
//

import SwiftData
import SwiftUI

struct DownloadView: View {
	@Query(sort: \Title.title) var savedTitles: [Title]
	@State private var titleDetailPath = NavigationPath()
	let headerTitle = Constants.likedTitleString

	var body: some View {
		NavigationStack(path: $titleDetailPath) {

			if savedTitles.isEmpty {
				Text("No added titles")
			} else {
				VerticalListView(
					titles: savedTitles,
					disableNav: true,
					onSelect: { title in
						titleDetailPath.append(title)
					}
				)
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
}

#Preview {
	DownloadView()
}
