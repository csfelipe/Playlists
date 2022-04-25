//
//  Playlist+Extended.swift
//  Playlists
//
//  Created by Felipe on 4/12/22.
//

import Foundation

extension Playlist {
    func echo() {
        var output = "\tPLAYLIST:"
        output += " \n\t\tid: \(id ?? UUID())"
        output += " \n\t\tname: \(name ?? "")"
        output += " \n\t\tdesc: \(desc ?? "")"
        output += " \n\t\thidden: \(hidden)"
        print(output)
    }
}
