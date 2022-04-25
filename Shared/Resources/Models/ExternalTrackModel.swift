//
//  ExternalTrackModel.swift
//  Playlists
//
//  Created by Felipe on 4/23/22.
//

import Foundation

struct ExternalTrackModel: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case name = "kMDItemDisplayName"
        case key = "kMDItemKeySignature"
        case genre = "kMDItemMusicalGenre"
        case authors = "kMDItemAuthors"
        case bpm = "kMDItemTempo"
        case dbId
    }
    
    var id: String {
        name + "-" +
        key + "-" +
        genre + "-" +
        "\(bpm)" + "-" +
        authors.joined(separator: "+")
    }

    let dbId: String
    let name: String
    let key: String
    let genre: String
    let authors: [String]
    let bpm: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        do {
            self.key = try container.decode(String.self, forKey: .key)
        } catch {
            self.key = ""
        }
        
        do {
            self.genre = try container.decode(String.self, forKey: .genre)
        } catch {
            self.genre = ""
        }
        
        do {
            self.authors = try container.decode([String].self, forKey: .authors)
        } catch {
            self.authors = []
        }
        
        do {
            self.bpm = try container.decode(Int.self, forKey: .bpm)
        } catch {
            self.bpm = 0
        }
        
        self.dbId = UUID().uuidString
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(key, forKey: .key)
        try container.encode(genre, forKey: .genre)
        try container.encode(authors, forKey: .authors)
        try container.encode(bpm, forKey: .bpm)
        try container.encode(dbId, forKey: .dbId)
    }
}
