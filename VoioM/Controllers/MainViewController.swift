//
//  MainViewController.swift
//  VoioM
//
//  Created by SHIN MIKHAIL on 17.12.2023.
//

import UIKit
import SnapKit
import Foundation

final class MainViewController: UIViewController {
    private var movies: [Movie] = [] // Массив для хранения фильмов
    //MARK: Properties
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search movie"
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .search
        // x clear button
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .systemGray
        clearButton.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        
        textField.rightView = clearButton
        textField.rightViewMode = .whileEditing
        return textField
    }()
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        return button
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    private let bottomMarginGuide = UILayoutGuide() // нижняя граница
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupDelegates()
        setupTarget()
    }
 
    private func setupConstraints() {
        view.backgroundColor = .white
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        view.addSubview(tableView)
        view.addLayoutGuide(bottomMarginGuide)
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(searchButton.snp.leading).offset(-20)
        }
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(searchTextField).offset(0)
            make.trailing.equalTo(view).offset(-20)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(bottomMarginGuide.snp.top)
        }
        bottomMarginGuide.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view)
            make.height.equalTo(80)
        }
    }
    // delegates
    private func setupDelegates() {
        searchTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    // target
    private func setupTarget() {
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    // x button tapped
    @objc private func clearButtonTapped() {
        searchTextField.text = ""
        clearTable()
    }
    // clear table with x button
    private func clearTable() {
        movies.removeAll()
        tableView.reloadData()
    }
    // search button
    @objc private func searchButtonTapped() {
        if let query = searchTextField.text, !query.isEmpty {
            // Выполняем поиск только если введен непустой запрос
            searchMovies(query: query)
        }
    }
    // Метод для выполнения запроса к iTunes Search API
    private func searchMovies(query: String) {
        MovieSearchService.shared.searchMovies(withQuery: query) { [weak self] (movies, error) in
            if let error = error {
                print("Error searching movies: \(error.localizedDescription)")
                return
            }
            
            if let movies = movies {
                // Обновляем массив с найденными фильмами
                self?.movies = movies
                // Обновляем таблицу на основе полученных данных
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
} // end
//MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Обработка события "Return" на клавиатуре
        textField.resignFirstResponder()
        if let query = textField.text, !query.isEmpty {
            // Выполняем поиск только если введен непустой запрос
            searchMovies(query: query)
        }
        return true
    }
}
//MARK: - UITableView
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let movie = movies[indexPath.row]
        cell.textLabel?.text = "\(movie.trackName) by \(movie.artistName)"
        return cell
    }
}
//MARK: - fetch
class MovieSearchService {
    static let shared = MovieSearchService()
    
    private init() {}
    
    func searchMovies(withQuery query: String, completion: @escaping ([Movie]?, Error?) -> Void) {
        guard let url = buildURL(withQuery: query) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data received", code: 0, userInfo: nil))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(MovieSearchResult.self, from: data)
                completion(result.results, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
    private func buildURL(withQuery query: String) -> URL? {
        let baseURL = "https://itunes.apple.com/search"
        let mediaType = "movie"
        let parameters = ["media": mediaType, "term": query]
        
        var components = URLComponents(string: baseURL)
        components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        return components?.url
    }
}
//MARK: - Struct
struct Movie: Codable {
    let trackName: String
    let artistName: String
}

struct MovieSearchResult: Codable {
    let results: [Movie]
}
