//
//  SearchViewModel.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 11-01-26.
//

import Foundation

@Observable
class SearchViewModel {
    private(set) var errorMessage: String?
    private(set) var searchTitles: [Title] = []
    private let dataFetcher = DataFetcher()
    
    func getSearchTitles(by media: String, for title: String) async{
        do {
            errorMessage = nil
            
            if(searchTitles.isEmpty){
                searchTitles = try await dataFetcher.fetchTitles(for: media, by: "trending")
            } else {
                searchTitles = try await dataFetcher.fetchTitles(for: media, by: "search", with: title)
            }
            
            print(searchTitles)
        } catch {
            print("Error searching titles: \(error)")
            errorMessage = error.localizedDescription
        }
    }
}
