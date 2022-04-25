//
//  DataBaseInitializer.swift
//  Playlists
//
//  Created by Felipe on 4/12/22.
//

import CoreData
import Foundation
import SwiftUI

final class DataBaseInitializer {
    let persistenceController = PersistenceController.shared
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Track.category, ascending: true)],
        animation: .default)
    private var allTracks: FetchedResults<Track>
    
    var areTracksAdded: Bool {
        UserDefaults.standard.bool(forKey: "are_tracks_added")
    }
    
    var isPreparedPlaylistAdded: Bool {
        UserDefaults.standard.bool(forKey: "is_prepared_playlist_added")
    }
    
//    var items: [TrackModel] = [
//        TrackModel(name: "Name 0", category: "Category 1", bpm: 128, dbId: UUID()),
//        TrackModel(name: "Name 1", category: "Category 2", bpm: 130, dbId: UUID()),
//        TrackModel(name: "Name 2", category: "Category 2", bpm: 91, dbId: UUID()),
//        TrackModel(name: "Name 3", category: "Category 3", bpm: 110, dbId: UUID()),
//        TrackModel(name: "Name 4", category: "Category 4", bpm: 165, dbId: UUID()),
//        TrackModel(name: "Name 5", category: "Category 3", bpm: 132, dbId: UUID()),
//        TrackModel(name: "Name 6", category: "Category 3", bpm: 92, dbId: UUID()),
//        TrackModel(name: "Name 7", category: "Category 4", bpm: 86, dbId: UUID()),
//        TrackModel(name: "Name 8", category: "Category 1", bpm: 100, dbId: UUID()),
//        TrackModel(name: "Name 9", category: "Category 1", bpm: 110, dbId: UUID())
//    ]
    
    var items: [TrackModel] = []
    
    func markTracksAsAdded() {
        UserDefaults.standard.set(true, forKey: "are_tracks_added")
    }
    
    func markPreparedPlaylistAsAdded() {
        UserDefaults.standard.set(true, forKey: "is_prepared_playlist_added")
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func loadJson() {
        print("##@@## loadJson | 0 --0412")
        guard let data = readLocalFile(forName: "library") else {
            print("##@@## loadJson | 1 --0412")
            return
        }
        
        print("##@@## loadJson | 2 --0412")
        do {
            print("##@@## loadJson | 3 --0412")
            let tracks = try JSONDecoder().decode([TrackModel].self, from: data)
            print("##@@## loadJson | 4 --0412")
            print("all tracks: \(tracks)")
            items = tracks
        } catch {
            print("##@@## loadJson | 5 | error = \(error) --0412")
        }
    }
    
    func initialize() {
        createPreparedPlaylist()
        loadJson()
        addTracks()
    }
    
    func createPreparedPlaylist() {
        print("Adding Prepared Playlist")
        print("##@@## createPreparedPlaylist | 0 --0412")
        guard !isPreparedPlaylistAdded else {
            print("##@@## createPreparedPlaylist | 1 --0412")
            print("Prepared Playlist has already been added")
            listStoredPlaylists()
            return
        }
        
        print("##@@## createPreparedPlaylist | 2 --0412")
        let playlist = Playlist(context: persistenceController.container.viewContext)
        playlist.id = UUID()
        playlist.name = "prepared"
        playlist.hidden = false
        playlist.desc = UUID().uuidString
        
        do {
            print("##@@## createPreparedPlaylist | 3 --0412")
            try persistenceController.container.viewContext.save()
            print("##@@## createPreparedPlaylist | 4 --0412")
            markPreparedPlaylistAsAdded()
        } catch {
            print("##@@## createPreparedPlaylist | 5 --0412")
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func addTracks() {
        print("Adding tracks")
        guard !areTracksAdded else {
            print("Tracks have already been added")
            listStoredTracks()
            return
        }
        
        items.forEach { aTrackItem in
            let track = Track(context: persistenceController.container.viewContext)
            track.bpm = Int64(aTrackItem.bpm)
            track.category = aTrackItem.genre
            track.contextualId = aTrackItem.id
            track.name = aTrackItem.name
            track.id = UUID()
        }
        
        do {
            try persistenceController.container.viewContext.save()
            markTracksAsAdded()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func listStoredTracks() {
        let fetchRequest: NSFetchRequest<Track>
        fetchRequest = Track.fetchRequest()
        let context = persistenceController.container.viewContext
        
        do {
            let objects = try context.fetch(fetchRequest)
            
            objects.forEach { track in
                track.echo()
            }
        } catch {
            print("failed catching objects")
        }
    }
    
    func listStoredPlaylists() {
        let fetchRequest: NSFetchRequest<Playlist>
        fetchRequest = Playlist.fetchRequest()
        let context = persistenceController.container.viewContext
        
        do {
            let objects = try context.fetch(fetchRequest)
            
            objects.forEach { playlist in
                playlist.echo()
            }
        } catch {
            print("failed catching objects")
        }
    }
}
