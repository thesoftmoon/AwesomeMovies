//
//  DataFetch.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 23-11-25.
//

import Foundation

struct DataFetcher {
    
    let TMBDBaseUrl: String? = AppEnvironment.TMBDBaseUrl
    let TMBDApiKey: String? = AppEnvironment.TMBDApiKey
    let YtBaseUrl: String? = AppEnvironment.YtBaseUrl
    let YtApiKey: String? = AppEnvironment.YtApiKey
    
    func fetchAndDecode<T: Decodable>(url: URL, type: T.Type) async throws -> T {
        // Hacemos la peticion http con urlsession, el try nos da la opcion de agregar un throw para lanzar errores :D
        let(data, urlResponse) = try await URLSession.shared.data(from: url)
        
        guard let response = urlResponse as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkErrors.baseUrlResponse(underlyingError: NSError(
                domain: "DataFetcher",
                code: (urlResponse as? HTTPURLResponse)?.statusCode ?? -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP Response"]
            ))
        }
        
        let decoder = JSONDecoder()
        // traduce de snake case a camle case el json, ejemplo user_name: "Javiera" -> userName: "Javiera"
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Formateamos la data
        return try decoder.decode(type, from: data)
    }
    
    /// build URL for TMBD Api
    /// - Parameter media
    /// - Parameter type
    /// - Parameter searchString
    /// - Returns URL String
    private func buildUrl(media: String, type: String,  searchString: String? = nil) throws -> URL?{
        guard let TMBDBaseUrl = TMBDBaseUrl else {
            throw NetworkErrors.missingConfig
        }
        
        guard let TMBDApiKey = TMBDApiKey else {
            throw NetworkErrors.missingConfig
        }
        
        var path:String
        
        switch type {
        case "trending":
            path = "3/trending/\(media)/day"
        case "top_rated":
            path = "3/\(media)/top_rated"
        case "upcoming":
            path = "3/\(media)/upcoming"
        case "search":
            path = "3/\(type)/\(media)"
        default:
            throw NetworkErrors.urlBuildFailed
        }
        
        //if (type == "trending") {
          //  path = "3/trending/\(media)/day"
        //} else if (type == "top_rated"){
          //  path = "3/\(media)/top_rated"
        //} else if (type == "upcoming"){
          //  path = "3/\(media)/upcoming"
        //} else {
          //  throw NetworkErrors.urlBuildFailed
        //}
        
        var queryItems = [
            URLQueryItem(name: "api_key", value: TMBDApiKey)
        ]
        
        if let searchString {
            queryItems.append(URLQueryItem(name: "query", value: searchString))
        }
        
        guard let url = URL(string: TMBDBaseUrl)?
            .appending(path: path)
            .appending(queryItems: queryItems) else {
            throw NetworkErrors.urlBuildFailed
        }
        
        return url
    }
    
    func fetchTitles(for media: String, by type: String, with searchTitleString: String? = nil) async throws -> [Title] {
        let fetchTitleUrl = try buildUrl(media: media, type: type, searchString: searchTitleString)
        
        guard let fetchTitleUrl = fetchTitleUrl else {
            throw NetworkErrors.urlBuildFailed
        }
        
        print("Url para el fetch \(fetchTitleUrl)");
        
        var titles = try await fetchAndDecode(url: fetchTitleUrl, type: TMDBAPIObject.self).results
        
        // Le agregamos el path a las imagenes
        Constants.addPosterPath(to: &titles)
        
        // retornamos los titulos
        return titles
        
    }
    
    func fetchVideoId(for title: String) async throws -> String?{
        guard let YtBaseUrl = YtBaseUrl else {
            throw NetworkErrors.missingConfig
        }
        
        guard let YtApiKey = YtApiKey else {
            throw NetworkErrors.missingConfig
        }
        
        let trailerSearch = title + YtURLStrings.space.rawValue + YtURLStrings.trailer.rawValue
        
        guard let fetchVideoURL = URL(string: YtBaseUrl)?.appending(queryItems: [
            URLQueryItem(name: YtURLStrings.queryShorten.rawValue, value: trailerSearch),
            URLQueryItem(name: YtURLStrings.key.rawValue, value: YtApiKey)
        ]) else {
            throw NetworkErrors.urlBuildFailed
        }
        
        print("La url de busqueda: \(fetchVideoURL)")
        
        return try await fetchAndDecode(url: fetchVideoURL, type: YtSearchResponse.self).items?.first?.id?.videoId ?? ""
        
        
    }
    
}
