//
//  PlaylistModel.swift
//  Playlists
//
//  Created by Felipe on 4/14/22.
//

import Foundation

struct PlaylistModel: Identifiable {
    let id: UUID
    let name: String
    let numberOfItems: Int
}
