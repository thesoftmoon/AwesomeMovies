//
//  SearchViewModel.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 11-01-26.
//

import Foundation

@Observable
class SearchViewModel {
    
    enum FetchStatus {
        case notStarted
        case fetching
        case success
        case failed(underlyingError: Error)
    }
    
    private(set) var searchFetchStatus: FetchStatus = .notStarted
    private(set) var errorMessage: String?
    private(set) var searchTitles: [Title] = []
    private let dataFetcher = DataFetcher()
    
    func getSearchTitles(by media: String, for title: String) async{
		
		if(!searchTitles.isEmpty && title.isEmpty){
			return
		}
		
        searchFetchStatus = .fetching
        do {
            errorMessage = nil
            
            if(searchTitles.isEmpty || title.isEmpty){
				print("Is empty")
                searchTitles = try await dataFetcher.fetchTitles(for: media, by: "trending")
            } else {
				print("Is not empty")
                searchTitles = try await dataFetcher.fetchTitles(for: media, by: "search", with: title)
            }
			
            searchFetchStatus = .success
        } catch {
            print("Error searching titles: \(error)")
            errorMessage = error.localizedDescription
            searchFetchStatus = .failed(underlyingError: error)
        }
    }
}
