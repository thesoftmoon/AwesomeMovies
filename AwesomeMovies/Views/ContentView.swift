//
//  ContentView.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 19-11-25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            Tab(Constants.homeString, systemImage: Constants.homeIcon){
                HomeView()
            }
            Tab(Constants.upcomingString, systemImage: Constants.upcomingIcon){
                UpcomingView()
            }
            Tab(Constants.searchString, systemImage: Constants.searchIcon){
                SearchView()
            }
            Tab(Constants.likedTabTitle, systemImage: Constants.likedIcon){
                DownloadView()
            }
        }
		.tint(.main) // Here we tint all app system icons and elements
		.onAppear{
            print("App loaded...")
        }
    }
}

#Preview {
    ContentView()
}
