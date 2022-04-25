//
//  PlaylistsView.swift
//  Playlists
//
//  Created by Felipe on 4/12/22.
//

import SwiftUI

struct PlaylistsView: View {
    enum DisplayMode {
        case main
        case sheet
    }
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = PlaylistsViewModel()
    @State var isCreateNewPlaylistPresented: Bool = false
    var displayMode: DisplayMode = .main
    var trackToBePlaced: TrackModel?
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    switch displayMode {
                    case .main:
                        createPlaylistButtonForMainDisplayMode
                    case .sheet:
                        createPlaylistButtonForSheetDisplayMode
                    }
                }
                
                if !viewModel.playlists.isEmpty {
                    Section("Your playlists") {
                        ForEach(viewModel.playlists) { playlist in
                            switch displayMode {
                            case .main:
                                playlistViewForMainDisplayMode(playlist)
                            case .sheet:
                                playlistViewForSheetDisplayMode(playlist)
                            }
                        }
                    }
                }
            }
            .listStyle(.grouped)
            .onAppear {
                viewModel.load()
            }.sheet(isPresented: $isCreateNewPlaylistPresented) {
                viewModel.load()
            } content: {
                CreatePlaylistView()
            }
            .navigationTitle("Playlists")
        }
    }
    
    func playlistViewForMainDisplayMode(_ playlist: PlaylistModel) -> some View {
        NavigationLink {
            LibraryView(playlistId: playlist.id.uuidString)
        } label: {
            PlaylistView(playlist: playlist)
        }
    }
    
    func playlistViewForSheetDisplayMode(_ playlist: PlaylistModel) -> some View {
        PlaylistView(playlist: playlist) {
            viewModel.addTrack(trackToBePlaced, to: playlist)
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var createPlaylistButtonForMainDisplayMode: some View {
        Button("+ Create New Playlist") {
            isCreateNewPlaylistPresented.toggle()
        }
    }
    
    var createPlaylistButtonForSheetDisplayMode: some View {
        NavigationLink("+ Create New Playlist") {
            CreatePlaylistView(needsNavigation: false)
        }
    }
}

struct PlaylistsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistsView()
    }
}
