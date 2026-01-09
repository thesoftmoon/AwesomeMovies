//
//  Constants.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 19-11-25.
//

import Foundation
import SwiftUI

struct Constants {
    static let homeString = "Home"
    static let homeIcon = "house"
    
    static let upcomingString = "Upcoming"
    static let upcomingIcon = "play.circle"
    static let upcomingMoviesString = "Upcoming movies"
    static let trendingMovieString = "Trending Movies"
    static let trendingTvShows = "Trending TV Shows"
    static let topRatedMoviesString = "Top Rated Movies"
    static let topRatedTvString = "Top Rated TV Shows"
    
    static let movieSearchString = "Movie Search"
    static let tvSearchString = "TV Search"
    
    //Icons
    static let tvIconString = "tv"
    static let movieIconString = "movieclapper"
    
    
    static let searchString = "Search"
    static let searchIcon = "magnifyingglass"
    
    static let downloadString = "Download"
    static let downloadIcon = "arrow.down.to.line"
    
    static let playString = "Play"
    
    static let testMovieImage1 = "https://image.tmdb.org/t/p/w500/nnl6OWkyPpuMm595hmAxNW3rZFn.jpg"
    static let testMovieImage2 = "https://image.tmdb.org/t/p/w500/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg"
    static let testMovieImage3 = "https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg"
    
    static let posterUrlStart = "https://image.tmdb.org/t/p/w500"
    
    // Funcion para añadir el path base al url que trae el api
    static func addPosterPath(to titles: inout[Title]) {
        for index in titles.indices {
            if let path = titles[index].posterPath {
                titles[index].posterPath = Constants.posterUrlStart + path
            }
        }
    }
}

enum YtURLStrings: String {
    case trailer = "trailer"
    case queryShorten = "q"
    case key = "key"
    case space = " "
}

extension Text {
    // This create a function that return a View
    func ghostButton()-> some View {
        self
            .frame(width: 100, height: 50)
            .foregroundStyle(.buttonText)
            .bold()
            .background(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(.buttonBorder,lineWidth: 4)
            )
    }
}
