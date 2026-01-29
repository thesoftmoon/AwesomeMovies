//
//  Title.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 20-11-25.
//

import SwiftData

struct TMDBAPIObject: Decodable {
    var results: [Title] = []
}

// Decodable allows swift to create the object from data source and identifiable get the id from it
// Hashable let Swift identify if the title are the same, like an ID
@Model
class Title: Decodable, Identifiable, Hashable {
    var id: Int?
    // The ' is for optional properties
    var title: String?
    var name: String?
    var overview: String?
    var posterPath: String?
	
	init(id: Int? = nil, title: String? = nil, name: String? = nil, overview: String? = nil, posterPath: String? = nil) {
		self.id = id
		self.title = title
		self.name = name
		self.overview = overview
		self.posterPath = posterPath
	}
	
	enum CodingKeys: CodingKey {
		case id
		case title
		case name
		case overview
		case posterPath
	}
	
	required init(from decoder: any Decoder) throws {
		//	this line creates a container to allows acces
		//	to JSON data using the keys defined in CodingKeys
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decodeIfPresent(Int.self, forKey: .id)
		title = try container.decodeIfPresent(String.self, forKey: .title)
		name = try container.decodeIfPresent(String.self, forKey: .name)
		overview = try container.decodeIfPresent(String.self, forKey: .overview)
		posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
	}
    
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

// Add JSON like debug string to see the content of the model in a print()
extension Title: CustomDebugStringConvertible {
	var debugDescription: String {
		"""
		Title(
			id: \(id ?? -1),
			title: \(title ?? "nil"),
			name: \(name ?? "nil"),
			overview: \(overview ?? "nil"),
			posterPath: \(posterPath ?? "nil")
		)
		"""
	}
}
