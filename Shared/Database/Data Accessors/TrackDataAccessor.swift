//
//  TrackDataAccessor.swift
//  Playlists
//
//  Created by Felipe on 4/14/22.
//

import CoreData
import Foundation

struct TrackDataAccessor {
    let persistenceController = PersistenceController.shared
    
    func getAllTracks() -> [TrackModel] {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<Track>
        fetchRequest = Track.fetchRequest()
        
        do {
            let trackData = try context.fetch(fetchRequest)
            let trackModels = trackData
                .compactMap { $0.toModel() }
                .sorted { $0.name < $1.name } 
            
            return trackModels
        } catch {
            return []
        }
    }
    
    func getTrack(with id: String) -> TrackModel? {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<Track>
        fetchRequest = Track.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        do {
            guard let track = try context.fetch(fetchRequest).first else {
                return nil
            }
            return track.toModel()
        } catch {
            return nil
        }
    }
}
