//
//  SearchView.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 02-01-26.
//

import SwiftUI

struct SearchView: View {
    
    var titles = Title.previewTitles
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]){
                    ForEach(titles) { title in
                        AsyncImage(url: URL(string: title.posterPath ?? "")){image in
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
        }
    }
}

#Preview {
    SearchView()
}
