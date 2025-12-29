//
//  YtSearchResponse.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 25-12-25.
//

import Foundation


struct YtSearchResponse: Codable {
    let items: [ItemProperties]?
}

struct ItemProperties: Codable {
    let id: IdProperties?
}

struct IdProperties: Codable {
    let videoId: String?
}
