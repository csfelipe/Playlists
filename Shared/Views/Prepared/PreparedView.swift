//
//  PreparedView.swift
//  Playlists
//
//  Created by Felipe on 4/12/22.
//

import SwiftUI

struct PreparedView: View {
    
    @ObservedObject var viewModel = PreparedViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(viewModel.unplayedTracks) { track in
                        TrackView(track: track)
                            .swipeActions {
                                Button("Played") {
                                    viewModel.markTrackAsPlayed(track)
                                }
                                .tint(.blue)
                                
                                Button("Remove") {
                                    viewModel.removeTrackFromPlaylist(track)
                                }
                                .tint(.red)
                            }
                    }
                }
                
                if !viewModel.playedTracks.isEmpty {
                    Section("Played") {
                        ForEach(viewModel.playedTracks) { track in
                            TrackView(track: track)
                                .swipeActions {
                                    Button("Put back") {
                                        viewModel.markTrackAsUnplayed(track)
                                    }
                                    .tint(.green)
                                }
                        }
                    }
                }
            }
            .listStyle(.grouped)
            .navigationBarTitle("Prepared")
            .onAppear {
                viewModel.load()
            }
        }
    }
}

struct PreparedView_Previews: PreviewProvider {
    static var previews: some View {
        PreparedView()
    }
}
