//
//  TitlesDetailVew.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 19-12-25.
//

import SwiftUI
import SwiftData

struct TitlesDetailVew: View {
	@Environment(\.modelContext) var modelContext
	// Now we can pass a title like a prop from parent view
	let title: Title
	@Query var savedTitles: [Title]

	let viewModel = ViewModel()
	var titleName: String {
		return (title.name ?? title.title) ?? ""
	}
	
	private var isLiked: Bool {
		savedTitles.contains(where: { $0.id == title.id })
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
								
								// We make the reference, delete or insert in this case
								if isLiked {
									if let toRemove = savedTitles.first(where: {$0.id == title.id}) {
										modelContext.delete(toRemove)
									}
								} else {
									// A new instance work better to update liked status
									let titleToSave = Title(
										id: title.id,
										title: titleName,
										overview: title.overview,
										posterPath: title.posterPath
									)
									modelContext.insert(titleToSave)
								}
								//Then we save the operation
								try? modelContext.save()

							} label: {
								
								LikedBtn(isLiked: isLiked)

							}

							Spacer()
						}

					}
				}
			case .failed(let underlyingError):
				Text(underlyingError.localizedDescription)
					.errorMsg()
			}
		}.task {
			await viewModel.getVideoId(for: titleName)
			print("Esta guardado: \(isLiked)")
		}
	}
}

#Preview {
	TitlesDetailVew(title: Title.previewTitles[0])
}
