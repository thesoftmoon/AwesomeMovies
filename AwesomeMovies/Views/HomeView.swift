//
//  HomeView.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 19-11-25.
//

import SwiftUI

struct HomeView: View {
    // Creamos un nuevo ViewModel par controlar la UI
    let viewModel = ViewModel()
    @State private var titleDetailPath = NavigationPath()
       
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
                            .frame(width: geo.size.width, height: geo.size.height)
                        
                    case .success:
                        LazyVStack {
                            // This load the image in async form, and when it loads show a progress circle :D
                            AsyncImage(url: URL(string: viewModel.heroTitle.posterPath ?? "")){image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .overlay(LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: .clear, location: 0.7),
                                            Gradient.Stop(color: .gradient, location: 1)],
                                        startPoint: .top,
                                        endPoint: .bottom))
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: geo.size.width, height: geo.size.height * 0.85)
                            
                            HStack{
                                Button {
                                    // Here you put the button does
                                    titleDetailPath.append(viewModel.heroTitle)
                                } label: {
                                    //Here you put the button design
                                    Text(Constants.playString)
                                        .ghostButton()
                                }
                                
                                Button {
                                    // Here you put the button does
                                } label: {
                                    //Here you put the button design
                                    Text(Constants.downloadString)
                                        .ghostButton()
                                }
                            }
                            
                            HorizontalListView(header: Constants.topRatedMoviesString,
                                               titles: viewModel.topRatedMovies,
                                               onSelect: { title in
                                                    titleDetailPath.append(title)
                                                })
                            HorizontalListView(header: Constants.trendingMovieString,
                                               titles: viewModel.trendingMovies,
                                               onSelect: { title in
                                                    titleDetailPath.append(title)
                                                })
                            
                            HorizontalListView(header: Constants.topRatedTvString,
                                               titles: viewModel.topRatedTvShows,
                                               onSelect: { title in
                                                    titleDetailPath.append(title)
                                                })
                            
                            HorizontalListView(header: Constants.trendingTvShows,
                                               titles: viewModel.trendingTvShows,
                                               onSelect: { title in
                                                    titleDetailPath.append(title)
                                                })
                        }
                        
                    case .failed(let error):
                        Text("Error: \(error)")
                    }
                }
                .task{
                    await viewModel.getTitles()
                }
                // Here we can define the global route, we call it like titleDetailPath.append(title)
                .navigationDestination(for: Title.self){ title in
                    TitlesDetailVew(title: title)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
