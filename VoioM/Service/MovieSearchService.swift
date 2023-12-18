//
//  MovieSearchService.swift
//  VoioM
//
//  Created by SHIN MIKHAIL on 18.12.2023.
//

import Foundation

final class MovieSearchService {
    static let shared = MovieSearchService()
    
    private init() {}
    
    private func buildURL(withQuery query: String) -> URL? {
        let baseURL = "https://itunes.apple.com/search"
        let mediaType = "movie"
        let parameters = ["media": mediaType, "term": query]
        
        var components = URLComponents(string: baseURL)
        components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        let url = components?.url
        print("Built URL: \(url?.absoluteString ?? "nil")")
        return url
    }
    // search
    func searchMovies(withQuery query: String, completion: @escaping ([Movie]?, Error?) -> Void) {
        guard let url = buildURL(withQuery: query) else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            print("Error building URL: \(error)")
            completion(nil, error)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("URL Session Error: \(error)")
                completion(nil, error)
                return
            }

            guard let data = data else {
                let error = NSError(domain: "No data received", code: 0, userInfo: nil)
                print("No data received. Error: \(error)")
                completion(nil, error)
                return
            }

            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(MovieSearchResult.self, from: data)
//                print("Decoded result: \(result)")
                var moviesWithDescriptions = result.results
                // change date format
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

                for (index, movie) in moviesWithDescriptions.enumerated() {
                    if let date = dateFormatter.date(from: movie.releaseDate) {
                        let newDateFormat = DateFormatter()
                        newDateFormat.dateFormat = "yyyy-MM-dd" // new format
                        moviesWithDescriptions[index].releaseDate = newDateFormat.string(from: date)
                    }
                }
                completion(moviesWithDescriptions, nil)
            } catch {
                print("Decoding error: \(error)")
                completion(nil, error)
            }
        }
        task.resume()
    }
} // end
