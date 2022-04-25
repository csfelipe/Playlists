//
//  PlaylistsViewModel.swift
//  Playlists
//
//  Created by Felipe on 4/12/22.
//

import CoreData
import Foundation

final class PlaylistsViewModel: ObservableObject {
    var playlistDataAccessor = PlaylistDataAccessor()
    var playlistItemsDataAccessor = PlaylistItemDataAccessor()
    @Published var playlists: [PlaylistModel] = []
    
    func load() {
        playlists = playlistDataAccessor.getPlaylists()
            .filter { shouldPlaylistsBeIncluded($0) }
            .compactMap { convertDataToModel($0) }
    }
    
    func shouldPlaylistsBeIncluded(_ playlist: Playlist) -> Bool {
        guard let name = playlist.name, name != "prepared" else {
            return false
        }
        return !playlist.hidden
    }
    
    func convertDataToModel(_ playlist: Playlist) -> PlaylistModel? {
        guard let name = playlist.name,
              let id = playlist.id else {
                  return nil
        }
        
        let numberOfItems = playlistItemsDataAccessor.getItems(playlistId: id.uuidString).count
        
        return PlaylistModel(id: id, name: name, numberOfItems: numberOfItems)
    }
    
    func addTrack(_ track: TrackModel?, to playlist: PlaylistModel) {
        guard let track = track else { return }
        playlistItemsDataAccessor.createItem(playlistId: playlist.id, trackId: track.dbId)
    }
}
