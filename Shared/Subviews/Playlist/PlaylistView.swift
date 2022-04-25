//
//  PlaylistView.swift
//  Playlists
//
//  Created by Felipe on 4/14/22.
//

import Foundation
import SwiftUI

struct PlaylistView: View {
    enum DisplayMode {
        case button
        case navigationItem
    }
    
    let displayMode: DisplayMode = .button
    let playlist: PlaylistModel
    var action: (() -> Void)? 
    
    var body: some View {
        Button(action: { action?() }) {
            buttonContentView
        }
    }
    
    var buttonContentView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(playlist.name)")
                .font(Font.headline)
                .bold()
            Text(numberOfTtacksText)
                .font(Font.caption)
        }
    }
    
    var numberOfTtacksText: String {
        let text: String
        if playlist.numberOfItems == 0 {
            text = "No tracks"
        } else if playlist.numberOfItems == 1 {
            text = "1 track"
        } else {
            text = "\(playlist.numberOfItems) tracks"
        }
        return text
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView(playlist: PlaylistModel(id: UUID(), name: "Playlist 1", numberOfItems: 89), action: {})
    }
}
