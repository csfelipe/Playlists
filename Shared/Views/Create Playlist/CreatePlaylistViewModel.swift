//
//  CreatePlaylistViewModel.swift
//  Playlists
//
//  Created by Felipe on 4/15/22.
//

import Foundation

final class CreatePlaylistViewModel {
    var playlistDataAccessor = PlaylistDataAccessor()
    
    func createPlaylist(named playlistName: String, completion: (_ successful: Bool) -> Void) {
        guard !playlistName.isEmpty else {
            completion(false)
            return
        }
        playlistDataAccessor.createPlaylist(named: playlistName)
        completion(true)
    }
}
