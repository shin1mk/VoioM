//
//  Movie.swift
//  VoioM
//
//  Created by SHIN MIKHAIL on 18.12.2023.
//

import Foundation

struct Movie: Codable {
    let trackName: String
    let artistName: String
    let artworkUrl100: String // URL обложки
    var releaseDate: String // Год
    let primaryGenreName: String // Жанр
    var longDescription: String? // Описание
    
    enum CodingKeys: String, CodingKey {
        case trackName
        case artistName
        case artworkUrl100
        case releaseDate
        case primaryGenreName
        case longDescription
    }
}

struct MovieSearchResult: Codable {
    let results: [Movie]
}
