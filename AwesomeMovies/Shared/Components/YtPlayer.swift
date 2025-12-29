//
//  YtPlayer.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 20-12-25.
//

import YouTubePlayerKit
import SwiftUICore
import SwiftUI

struct YtPlayer: View {
    let videoId: String
    var player: YouTubePlayer
    
    init(videoId: String){
        self.videoId = videoId
        self.player = YouTubePlayer(source: .video(id: videoId))
    }
    
    var body: some View {
        YouTubePlayerView(player) {
            state in
            
            // Here we need to return a view, run only a print() if it is not assigned to a constant, it will throw an error
            // With _ we can return undefinde or nothing is a symbol that swift ignores and run the print()
            let _ = print("Estado: \(state)")
            
            switch state {
            case .idle:
                ProgressView()
            case .ready:
                EmptyView()
            case .error(let error):
                            ContentUnavailableView(
                                "Error",
                                systemImage: "exclamationmark.triangle.fill",
                                description: Text("YouTube player couldn't be loaded: \(error)")
                            )
                        }
        }
    }
}
