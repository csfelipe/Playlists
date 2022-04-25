//
//  PreparedViewModel.swift
//  Playlists
//
//  Created by Felipe on 4/12/22.
//

import Foundation

final class PreparedViewModel: ObservableObject {
    @Published var playedTracks: [TrackModel] = []
    @Published var unplayedTracks: [TrackModel] = []
    
    var playlistDataAccessor = PlaylistDataAccessor()
    var trackDataAccessor = TrackDataAccessor()
    var playlistItemDataAccessor = PlaylistItemDataAccessor()
    
    private func getPlaylistId() -> UUID? { playlistDataAccessor.getPlaylistId(byName: "prepared") }
    
    func load() {
        guard let id = getPlaylistId() else { return }
        
        playlistItemDataAccessor.echoPlaylistItems(playlistId: id.uuidString)
        
        let items = playlistItemDataAccessor.getItems(playlistId: id.uuidString)

        guard !items.isEmpty else { return }
        
        playedTracks.removeAll()
        unplayedTracks.removeAll()
        
        items.forEach { item in
            if let trackId = item.trackId,
               let track = trackDataAccessor.getTrack(with: trackId.uuidString) {
                switch item.datePlayed {
                case .some:
                    playedTracks.append(track)
                case .none:
                    unplayedTracks.append(track)
                }
            }
        }
    }
    
    private func updateTrackWith(datePlayed: Date?, trackId: String) {
        guard let id = getPlaylistId() else { return }
        guard let item = playlistItemDataAccessor.getItem(playlistId: id.uuidString, trackId: trackId) else { return }
        
        item.datePlayed = datePlayed
        
        playlistItemDataAccessor.saveUpdatesToItem(item)
        playlistItemDataAccessor.echoPlaylistItems(playlistId: id.uuidString)
        
        load()
    }
    
    func markTrackAsPlayed(_ track: TrackModel) {
        updateTrackWith(datePlayed: Date(), trackId: track.dbId.uuidString)
    }
    
    func markTrackAsUnplayed(_ track: TrackModel) {
        updateTrackWith(datePlayed: nil, trackId: track.dbId.uuidString)
    }
    
    func removeTrackFromPlaylist(_ track: TrackModel) {
        guard let id = getPlaylistId() else { return }
        guard let item = playlistItemDataAccessor.getItem(playlistId: id.uuidString, trackId: track.dbId.uuidString) else { return }
        
        playlistItemDataAccessor.deleteItem(item)
        
        if let index = playedTracks.firstIndex(of: track) {
            playedTracks.remove(at: index)
        } else if let index = unplayedTracks.firstIndex(of: track) {
            unplayedTracks.remove(at: index)
        } else {
            print("No item to be removed")
        }
    }
}
