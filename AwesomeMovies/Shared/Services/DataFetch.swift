//
//  DataFetch.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 23-11-25.
//

import Foundation

struct DataFetcher {
    
    let baseUrl: String? = ApiConfig.shared?.tmdbBaseUrl
    let apiKey: String? = ApiConfig.shared?.tmdbApiKey
    let ytSearchUrl: String? = ApiConfig.shared?.ytSearchUrl
    let ytApiKey: String? = ApiConfig.shared?.ytApiKey
    
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
    
    private func buildUrl(media: String, type: String) throws -> URL?{
        guard let baseUrl = baseUrl else {
            throw NetworkErrors.missingConfig
        }
        
        guard let apiKey = apiKey else {
            throw NetworkErrors.missingConfig
        }
        
        var path:String
        
        if (type == "trending") {
            path = "3/trending/\(media)/day"
        } else if (type == "top_rated"){
            path = "3/\(media)/top_rated"
        } else if (type == "upcoming"){
            path = "3/\(media)/upcoming"
        } else {
            throw NetworkErrors.urlBuildFailed
        }
        
        guard let url = URL(string: baseUrl)?
            .appending(path: path)
            .appending(queryItems: [
                URLQueryItem(name: "api_key", value: apiKey)
            ]) else {
            throw NetworkErrors.urlBuildFailed
        }
        
        
        return url
    }
    
    func fetchTitles(for media: String, by type: String) async throws -> [Title] {
        let fetchTitleUrl = try buildUrl(media: media, type: type)
        
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
        guard let ytSearchUrl = ytSearchUrl else {
            throw NetworkErrors.missingConfig
        }
        
        guard let ytApiKey = ytApiKey else {
            throw NetworkErrors.missingConfig
        }
        
        let trailerSearch = title + YtURLStrings.space.rawValue + YtURLStrings.trailer.rawValue
        
        guard let fetchVideoURL = URL(string: ytSearchUrl)?.appending(queryItems: [
            URLQueryItem(name: YtURLStrings.queryShorten.rawValue, value: trailerSearch),
            URLQueryItem(name: YtURLStrings.key.rawValue, value: ytApiKey)
        ]) else {
            throw NetworkErrors.urlBuildFailed
        }
        
        print("La url de busqueda: \(fetchVideoURL)")
        
        return try await fetchAndDecode(url: fetchVideoURL, type: YtSearchResponse.self).items?.first?.id?.videoId ?? ""
        
        
    }
    
}
