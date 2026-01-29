//
//  TitlesDetailVew.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 19-12-25.
//

import SwiftUI

struct TitlesDetailVew: View {
	@Environment(\.modelContext) var modelContext
	// Now we can pass a title like a prop from parent view
	let title: Title
	let videoId: String = "eBjzQ1NCXQ4"

	let viewModel = ViewModel()
	var titleName: String {
		return (title.name ?? title.title) ?? ""
	}
	var body: some View {

		GeometryReader { geo in
			switch viewModel.videoIdFetchStatus {
			case .notStarted:
				EmptyView()
			case .fetching:
				ProgressView()
					.frame(width: geo.size.width, height: geo.size.height)
			case .success:
				ScrollView {
					LazyVStack(alignment: .leading) {
						YtPlayer(videoId: viewModel.videoId)
							.aspectRatio(1.3, contentMode: .fit)

						Text((title.name ?? title.title) ?? "")
							.bold()
							.font(.title2)
							.padding(5)
							.padding(.top, -5)

						Text(title.overview ?? "")
							.padding(5)

						HStack {
							Spacer()

							Button {
								
								print("Downloading... \(titleName)")
								
								let titleToSave = title
								titleToSave.title = titleName
								
								// We referenced it
								modelContext.insert(titleToSave)
								// Then we saved it
								try? modelContext.save()
								
							} label: {
								Text(Constants.downloadString)
									.ghostButton()
							}

							Spacer()
						}

					}
				}
			case .failed(let underlyingError):
				Text(underlyingError.localizedDescription)
			}
		}.task {
			await viewModel.getVideoId(for: titleName)
		}
	}
}

#Preview {
	TitlesDetailVew(title: Title.previewTitles[0])
}
