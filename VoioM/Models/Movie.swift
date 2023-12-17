//
//  Movie.swift
//  VoioM
//
//  Created by SHIN MIKHAIL on 18.12.2023.
//

import Foundation
//MARK: - Struct
struct Movie: Codable {
    let trackName: String
    let artistName: String
}

struct MovieSearchResult: Codable {
    let results: [Movie]
}
