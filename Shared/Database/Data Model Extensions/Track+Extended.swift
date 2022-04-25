//
//  Track+Extended.swift
//  Playlists
//
//  Created by Felipe on 4/12/22.
//

import Foundation

extension Track {
    func toModel() -> TrackModel {
        TrackModel(
            databasebId: id?.uuidString ?? "",
            name: name ?? "",
            key: "",
            genre: category ?? "",
            authors: [],
            bpm: Int(bpm)
            
//            name: name ?? "",
//            category: category ?? "",
//            bpm: bpm,
//            dbId: id ?? UUID()
        )
        
    }
    
    func echo() {
        var output = "\tTRACK:"
        output += " \n\t\tname: \(name ?? "")"
        output += " \n\t\tgenre: \(category ?? "")"
        output += " \n\t\tbpm: \(bpm)"
        output += " \n\t\tcontextualId: \(contextualId ?? "")"
        print(output)
    }
}
