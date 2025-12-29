//
//  Errors.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 22-11-25.
//

import Foundation


enum apiConfigErrors: Error, LocalizedError {
    case fileNotFound
    case dataLoadingFailed(underlyingError: Error)
    case decodingFailed(underlyingError: Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "Api configuration file not found"
        case .dataLoadingFailed(underlyingError: let error):
            return "Failed to load data from api configuration file: \(error.localizedDescription)"
        case .decodingFailed(underlyingError: let error):
            return "Failed to decode api configuration \(error.localizedDescription)"
        }
    }
}

enum NetworkErrors: Error, LocalizedError {
    case baseUrlResponse(underlyingError: Error)
    case missingConfig
    case urlBuildFailed
    
    var errorDescription: String? {
        switch self {
            
        case .baseUrlResponse(underlyingError: let error):
            return "Failed to parse url response: \(error.localizedDescription)"
        case .missingConfig:
            return "Missing api configuration"
            
        case .urlBuildFailed:
            return "Failed to build Url"
        }
        
        
    }
}
