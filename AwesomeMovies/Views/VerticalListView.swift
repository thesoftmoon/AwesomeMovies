//
//  VerticalListView.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 27-12-25.
//

import SwiftUI

struct VerticalListView: View {
    var header: String
    var titles: [Title]
    let onSelect: (Title)-> Void // Prop function to pass data to father view
    
    var body: some View {
        
        Text(header).font(.title)
        
        VStack(alignment: .leading) {
            Text("Upcoming movies").font(.title)
            List(titles){title in
                AsyncImage(url: URL(string: title.posterPath ?? "")){ image in
                    HStack{ image
                        .resizable()
                        .scaledToFit()
                        .clipShape(.rect(cornerRadius: 15))
                        .padding(5)
                        
                        Text((title.name ?? title.title) ?? "")
                            .font(.system(size: 14))
                            .bold()
                    }
                    
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 150)
                .onTapGesture {
                    onSelect(title)
                }
            }
        }
    }
}

#Preview {
    VerticalListView(header: Constants.upcomingString ,titles: Title.previewTitles){titles in
    }
}
