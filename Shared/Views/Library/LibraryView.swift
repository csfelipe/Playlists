//
//  LibraryView.swift
//  Playlists
//
//  Created by Felipe on 4/12/22.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject var viewModel = LibraryViewModel()
    @State var isPlaylistPresented: Bool = false
    var playlistId: String?
    
    var body: some View {
        switch playlistId {
        case .none:
            NavigationView {
                listView
            }
        case .some:
            listView
        }
    }
    
    var listView: some View {
        List {
            ForEach(viewModel.tracks) { track in
                TrackView(track: track)
                    .swipeActions {
                        switch playlistId {
                        case .none:
                            swipeActionForLibrary(using: track)
                        case .some:
                            swipeActionForPlaylist(using: track)
                        }
                    }
            }
        }
        .navigationTitle(navitationTitle)
        .listStyle(.grouped)
        //            .toolbar {
        //#if os(iOS)
        //                ToolbarItem(placement: .navigationBarTrailing) {
        //                    EditButton()
        //                }
        //#endif
        ////                ToolbarItem {
        ////                    Button(action: addItem) {
        ////                        Label("Add Item", systemImage: "plus")
        ////                    }
        ////                }
        //            }
        .sheet(isPresented: $isPlaylistPresented) {
            viewModel.resetSavedTrack()
        } content: {
            PlaylistsView(displayMode: .sheet, trackToBePlaced: viewModel.lastSavedTrack)
        }
        .onAppear {
            viewModel.load(for: playlistId)
        }
    }
    
    @ViewBuilder func swipeActionForLibrary(using track: TrackModel) -> some View {
        Button("Playlist") {
            viewModel.addTrackToPlaylist(track)
            isPlaylistPresented.toggle()
        }
        .tint(.yellow)
        
        Button("Prepare") {
            viewModel.addTrackToPrepareList(track)
        }
        .tint(.green)
    }
    
    @ViewBuilder func swipeActionForPlaylist(using track: TrackModel) -> some View {
        Button("Favorite") {
            print("favorite")
        }
        .tint(.yellow)
        
        Button("Remove") {
            print("removing")
        }
        .tint(.red)
    }
    
    var navitationTitle: String {
        switch playlistId {
        case .none:
            return "Library"
        case let .some(id):
            return viewModel.navigationTitleForPlaylist(id)
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
