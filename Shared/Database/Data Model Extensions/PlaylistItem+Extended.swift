//
//  PlaylistItem+Extended.swift
//  Playlists
//
//  Created by Felipe on 4/13/22.
//

import Foundation

extension PlaylistItem {
    func echo() {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
        
        var added = "date_not_available"
        if let a = dateAdded {
            added = formatter.string(from: a)
        }
        
        var played = "date_not_available"
        if let p = datePlayed {
            played = formatter.string(from: p)
        }
        
        var output = "\tPLAYLIST:"
        output += " \n\t\tplaylistId: \(playlistId ?? UUID())"
        output += " \n\t\ttrackId: \(trackId ?? UUID())"
        output += " \n\t\tdateAdded: \(added)"
        output += " \n\t\tdatePlayed: \(played)"
        print(output)
    }
}
