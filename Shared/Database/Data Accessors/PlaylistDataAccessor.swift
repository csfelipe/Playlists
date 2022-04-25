//
//  PlaylistDataAccessor.swift
//  Playlists
//
//  Created by Felipe on 4/14/22.
//

import CoreData
import Foundation

struct PlaylistDataAccessor {
    let persistenceController = PersistenceController.shared
    
    func getPlaylist(by playlistName: String) -> Playlist? {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<Playlist>
        fetchRequest = Playlist.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", "\(playlistName)")
        
        do {
            guard let playlist = try context.fetch(fetchRequest).first else {
                return nil
            }
            
            playlist.echo()
            return playlist
        } catch {
            return nil
        }
    }
    
    func getPlaylists() -> [Playlist] {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<Playlist>
        fetchRequest = Playlist.fetchRequest()
        
        do {
            let playlists = try context.fetch(fetchRequest)
            return playlists
        } catch {
            return []
        }
    }
    
    func getPlaylistId(byName playlistName: String) -> UUID? {
        guard let playlist = getPlaylist(by: playlistName) else {
            return nil
        }
        return playlist.id
    }
    
    func createPlaylist(named: String) {
        let context = persistenceController.container.viewContext
        let playlist = Playlist(context: context)
        playlist.id = UUID()
        playlist.name = named
        playlist.hidden = false
        playlist.desc = UUID().uuidString
        
        do {
            try context.save()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func getPlaylistName(for id: String) -> String? {
        getPlaylists().filter { $0.id?.uuidString == id }.first?.name
    }
}
