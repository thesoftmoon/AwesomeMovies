//
//  VerticalListView.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 27-12-25.
//

import SwiftUI

struct VerticalListView: View {
	var titles: [Title]
	var disableNav: Bool = false
	let onSelect: (Title) -> Void  // Prop function to pass data to father view
	@Environment(\.modelContext) var modelContext

	var body: some View {

		VStack(alignment: .leading) {
			List(titles) { title in
				AsyncImage(url: URL(string: title.posterPath ?? "")) { image in
					HStack {
						image
							.resizable()
							.scaledToFit()
							.clipShape(.rect(cornerRadius: 15))
							.padding(5)
						VStack(alignment: .leading) {
							Text((title.name ?? title.title) ?? "")
								.font(.system(size: 14))
								.bold()
							if disableNav {
								Text(title.overview ?? "")
									.font(.system(size: 11))
							}
						}

					}

				} placeholder: {
					ProgressView()
				}
				.frame(height: 150)
				.onTapGesture {
					if !disableNav {
						onSelect(title)
					}
				}
				.swipeActions(edge: .leading) {
					if disableNav {
						Button {
							modelContext.delete(title)
							try? modelContext.save()
							print("Deleting...")
						} label: {
							Image(systemName: "trash")
								.tint(.red)

						}
					}
				}

			}
		}
		.padding(.top, -45)
	}
}

#Preview {
	VerticalListView(
		titles: Title.previewTitles
	) { titles in
	}
}
