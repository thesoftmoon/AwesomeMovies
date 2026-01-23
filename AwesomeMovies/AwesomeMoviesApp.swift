//
//  AwesomeMoviesApp.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 19-11-25.
//

import SwiftUI
import SwiftData

@main
struct AwesomeMoviesApp: App {
    init() {
        print("App loaded...")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
		}
		.modelContainer(for: Title.self)
    }
}
