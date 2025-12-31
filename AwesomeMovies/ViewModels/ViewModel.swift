//
//  ViewModel.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 08-12-25.
//

import Foundation

//Nos permite actualizar el UI si cambia la data
@Observable

// Es el "intermediario" entre la pantalla (Vista) y los datos (Modelo).
class ViewModel {
    enum FetchStatus {
        case notStarted
        case fetching
        case success
        case failed(underlyingError: Error)
    }

    // Seteamos el estado default
    private(set) var homeStatus: FetchStatus = .notStarted
    private(set) var videoIdFetchStatus: FetchStatus = .notStarted
    private(set) var upcomingMoviesStatus: FetchStatus = .notStarted

    // Declaramos el datafetcher
    private let dataFetcher = DataFetcher()

    // Declaramos el array que almacenara los titulos
    var trendingMovies: [Title] = []
    var trendingTvShows: [Title] = []
    var topRatedTvShows: [Title] = []
    var topRatedMovies: [Title] = []
    var upcomingMovies: [Title] = []
    var heroTitle: Title = Title.previewTitles[0]
    var videoId: String = ""

    func getTitles() async {
        homeStatus = .fetching

        if trendingMovies.isEmpty {
            do {
                // Here w fetch the data
                // "async let" henable to fetch simultaneously all the endpoints
                async let tMovies = dataFetcher.fetchTitles(
                    for: "movie", by: "trending")
                async let tTvShows = dataFetcher.fetchTitles(
                    for: "tv", by: "trending")
                async let tRatedTvShows = dataFetcher.fetchTitles(
                    for: "tv", by: "top_rated")
                async let tRatedMovies = dataFetcher.fetchTitles(
                    for: "movie", by: "top_rated")

                trendingMovies = try await tMovies
                trendingTvShows = try await tTvShows
                topRatedTvShows = try await tRatedTvShows
                topRatedMovies = try await tRatedMovies

                if let title = trendingMovies.randomElement() {
                    heroTitle = title
                }
                homeStatus = .success
            } catch {
                print(error)
                homeStatus = .failed(underlyingError: error)
            }
        } else {
            homeStatus = .success
        }
    }

    func getVideoId(for title: String) async {
        videoIdFetchStatus = .fetching

        do {
            videoId = try await dataFetcher.fetchVideoId(for: title) ?? ""
            videoIdFetchStatus = .success
        } catch {
            print(error)
            videoIdFetchStatus = .failed(underlyingError: error)
        }

    }

    func getUpcomingMovies() async {
        upcomingMoviesStatus = .fetching
        do {
            upcomingMovies = try await dataFetcher.fetchTitles(
                for: "movie", by: "upcoming")
            upcomingMoviesStatus = .success
            print("Fetching upcoming movies")
        } catch {
            print("Error getting upcoming movies: \(error)")
            upcomingMoviesStatus = .failed(underlyingError: error)
        }
    }
}
