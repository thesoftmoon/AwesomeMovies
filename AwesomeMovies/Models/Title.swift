//
//  Title.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 20-11-25.
//

import Foundation

struct TMDBAPIObject: Decodable {
    var results: [Title] = []
}

// Decodable allows swift to create the object from data source and identifiable get the id from it
// Hashable let Swift identify if the title are the same, like an ID
struct Title: Decodable, Identifiable, Hashable {
    var id: Int?
    // The ' is for optional properties
    var title: String?
    var name: String?
    var overview: String?
    var posterPath: String?
    
    static var previewTitles = [
        Title(
        id: 1, title: "Beetlejuice",
        name: "Beetlejuice",
        overview: "Test",
        posterPath: Constants.testMovieImage1),
        
        Title(
        id: 2, title: "Beetlejuice 2",
        name: "Beetlejuice 2",
        overview: "Test",
        posterPath: Constants.testMovieImage2),
        
        Title(
        id: 3, title: "Beetlejuice 3",
        name: "Beetlejuice 3",
        overview: "Test",
        posterPath: Constants.testMovieImage3)
    ]
}
