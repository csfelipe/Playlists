//
//  TrackView.swift
//  Playlists
//
//  Created by Felipe on 4/12/22.
//

import SwiftUI

struct TrackView: View {
    
    let track: TrackModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(track.name)")
                .font(Font.headline)
                .bold()
            Text("\(track.genre)")
                .font(Font.footnote)
            Text("\(track.bpm)")
                .font(Font.caption)
        }
    }
}

struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView(track: TrackModel(databasebId: "", name: "Lets go", key: "", genre: "Disco", authors: [], bpm: 130))
    }
}
