//
//  MovieSearchService.swift
//  VoioM
//
//  Created by SHIN MIKHAIL on 18.12.2023.
//

import Foundation

class MovieSearchService {
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

//    func searchMovies(withQuery query: String, completion: @escaping ([Movie]?, Error?) -> Void) {
//        guard let url = buildURL(withQuery: query) else {
//            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
//            print("Error building URL: \(error)")
//            completion(nil, error)
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let error = error {
//                print("URL Session Error: \(error)")
//                completion(nil, error)
//                return
//            }
//            
//            guard let data = data else {
//                let error = NSError(domain: "No data received", code: 0, userInfo: nil)
//                print("No data received. Error: \(error)")
//                completion(nil, error)
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                let result = try decoder.decode(MovieSearchResult.self, from: data)
//                print("Decoded result: \(result)")
//                completion(result.results, nil)
//            } catch {
//                print("Decoding error: \(error)")
//                completion(nil, error)
//            }
//        }
//        
//        task.resume()
//    }
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
                print("Decoded result: \(result)")

                var moviesWithDescriptions = result.results
                // get description movie
                for (index, movie) in moviesWithDescriptions.enumerated() {
                    // Здесь предполагается, что API возвращает описание для каждого фильма в поле longDescription
                    moviesWithDescriptions[index].longDescription = movie.longDescription ?? "No description available."
                }

                completion(moviesWithDescriptions, nil)
            } catch {
                print("Decoding error: \(error)")
                completion(nil, error)
            }
        }

        task.resume()
    }

}
