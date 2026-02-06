//
//  LikedBtn.swift
//  AwesomeMovies
//
//  Created by Tomás  Pacheco on 06-02-26.
//

import SwiftUI

struct LikedBtn: View {
	
	var isLiked: Bool = false
	
    var body: some View {
		if isLiked {
			HStack{
				Image(systemName: "heart.fill")
				Text(Constants.likedBtnString)
			}.likedBtn()
		} else {
			HStack{
				Image(systemName: "heart")
				Text(Constants.likedBtnString)
			}.secondaryBtn()
		}
    }
}

#Preview {
    LikedBtn()
}
