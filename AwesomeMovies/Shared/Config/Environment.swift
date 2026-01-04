//
//  Environment.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 04-01-26.
//

import Foundation

enum Environment {
    static var TMBDBaseUrl: String {
        guard
            let value = Bundle.main.object(forInfoDictionaryKey: "TMBDBaseUrl")
                as? String
        else {
            fatalError("Missing TMBDB variable")
        }

        return "https://\(value)"
    }

    static var TMBDApiKey: String {
        guard
            let value = Bundle.main.object(forInfoDictionaryKey: "TMBDApiKey")
                as? String
        else {
            fatalError("Missing TMBDB variable")
        }

        return value
    }

    static var YtBaseUrl: String {
        guard
            let value = Bundle.main.object(forInfoDictionaryKey: "YtBaseUrl")
                as? String
        else {
            fatalError("Missing Yt variable")
        }

        return "https://\(value)"
    }

    static var YtApiKey: String {
        guard
            let value = Bundle.main.object(forInfoDictionaryKey: "YtApiKey")
                as? String
        else {
            fatalError("Missing Yt variable")
        }

        return value
    }

}
