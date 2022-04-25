//
//  PlaylistItemDataAccessor.swift
//  Playlists
//
//  Created by Felipe on 4/14/22.
//

import CoreData
import Foundation

struct PlaylistItemDataAccessor {
    let persistenceController = PersistenceController.shared
    
    func getItem(playlistId: String, trackId: String) -> PlaylistItem? {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<PlaylistItem>
        fetchRequest = PlaylistItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "playlistId = %@ AND trackId = %@", "\(playlistId)", "\(trackId)")
        
        do {
            guard let item = try context.fetch(fetchRequest).first else {
                return nil
            }
            return item
        } catch {
            return nil
        }
    }
    
    func getItems(playlistId: String) -> [PlaylistItem] {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<PlaylistItem>
        fetchRequest = PlaylistItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "playlistId = %@", "\(playlistId)")
        do {
            let itemsInPlaylist = try context.fetch(fetchRequest)
            return itemsInPlaylist
        } catch {
            return []
        }
    }
    
    func createItem(playlistId: UUID, trackId: UUID) {
        let context = persistenceController.container.viewContext
        
        guard !isTrackInPlaylist(trackId: trackId.uuidString, playlistId: playlistId.uuidString) else {
            return
        }
        
        let item = PlaylistItem(context: context)
        item.trackId = trackId
        item.playlistId = playlistId
        item.dateAdded = Date()
        
        do {
            try context.save()
        } catch {
            print("error: \(error)")
        }
    }
    
    func saveUpdatesToItem(_ playlisItem: PlaylistItem) {
        let context = persistenceController.container.viewContext
        
        do {
            try context.save()
        } catch {
            print("error: \(error)")
        }
    }
    
    func deleteItem(_ playlistItem: PlaylistItem) {
        let context = persistenceController.container.viewContext
        
        do {
            context.delete(playlistItem)
            try context.save()
        } catch {
            print("error: \(error)")
        }
    }
    
    func isTrackInPlaylist(trackId: String, playlistId: String) -> Bool {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<PlaylistItem>
        fetchRequest = PlaylistItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "playlistId = %@ AND trackId = %@", "\(playlistId)", "\(trackId)")
        
        do {
            let itemsInPlaylist = try context.fetch(fetchRequest)
            return !itemsInPlaylist.isEmpty
        } catch {
            return false
        }
    }
    
    func echoPlaylistItems(playlistId: String) {
        let items = getItems(playlistId: playlistId)
        items.forEach { $0.echo() }
    }
}
