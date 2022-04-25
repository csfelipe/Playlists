//
//  LibraryViewModel.swift
//  Playlists
//
//  Created by Felipe on 4/12/22.
//

import Foundation
import SwiftUI

final class LibraryViewModel: ObservableObject {
    @Published var tracks: [TrackModel] = []
    
    let persistenceController = PersistenceController.shared
    var trackDataAccessor = TrackDataAccessor()
    var playlistDataAccessor = PlaylistDataAccessor()
    var playlistItemDataAccessor = PlaylistItemDataAccessor()
    
    private(set) var lastSavedTrack: TrackModel?
    
    func load(for playlistId: String?) {
        tracks.removeAll()
        
        switch playlistId {
        case .none:
            tracks = trackDataAccessor.getAllTracks()
        case let .some(id):
            let items = playlistItemDataAccessor.getItems(playlistId: id)
            tracks = items.compactMap { playlistItemIntoTrack($0) }
        }
    }
    
    func playlistItemIntoTrack(_ playlistItem: PlaylistItem) -> TrackModel? {
        guard let trackId = playlistItem.trackId?.uuidString else {
            return nil
        }
        return trackDataAccessor.getTrack(with: trackId)
    }
    
    func addTrackToPrepareList(_ track: TrackModel) {
        guard let playlistId = playlistDataAccessor.getPlaylistId(byName: "prepared") else { return }
        guard !playlistItemDataAccessor.isTrackInPlaylist(trackId: track.dbId.uuidString, playlistId: playlistId.uuidString) else { return }
        playlistItemDataAccessor.createItem(playlistId: playlistId, trackId: track.dbId)
    }
    
    func addTrackToPlaylist(_ track: TrackModel) {
        lastSavedTrack = track
    }
    
    func resetSavedTrack() {
        lastSavedTrack = nil
    }
    
    func navigationTitleForPlaylist(_ id: String) -> String {
        playlistDataAccessor.getPlaylistName(for: id) ?? "Playlist"
    }
}
