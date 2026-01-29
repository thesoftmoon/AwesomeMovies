//
//  DownloadView.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 29-01-26.
//

import SwiftData
import SwiftUI

struct DownloadView: View {
	@Query var savedTitles: [Title]
	@State private var titleDetailPath = NavigationPath()

	var body: some View {
		NavigationStack(path: $titleDetailPath) {

			if savedTitles.isEmpty {
				Text("No movies to download")
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
			}

		}
	}
}

#Preview {
	DownloadView()
}
