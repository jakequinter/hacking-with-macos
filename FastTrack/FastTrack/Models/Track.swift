//
//  Track.swift
//  FastTrack
//
//  Created by Jake Quinter on 1/5/23.
//

import Foundation

struct Track: Decodable, Identifiable {
    let trackId: Int
    let artistName: String
    let trackName: String
    let previewUrl: URL
    let artworkUrl100: String
    
    var id: Int { trackId }
    
    var artworkURL: URL? {
        let replacedString = artworkUrl100.replacingOccurrences(of: "100x100", with: "300x300")
        
        return URL(string: replacedString)
    }
}

struct SearchResult: Decodable {
    let results: [Track]
}
