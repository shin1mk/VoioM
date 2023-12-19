//
//  MainViewController.swift
//  VoioM
//
//  Created by SHIN MIKHAIL on 17.12.2023.
//

import UIKit
import SnapKit
import Foundation

final class HomeViewController: UIViewController {
    private let movieSearchService = MovieSearchService.shared // загрузка по умолчанию
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
        clearButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
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
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieCell")
        return tableView
    }()
    private let bottomMarginGuide = UILayoutGuide() // нижняя граница
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupDelegates()
        setupTarget()
        loadChristmasMovies()
        addTapGestureToDismissKeyboard()
    }
    // загружаем фильмы по умолчанию
    private func loadChristmasMovies() {
        let christmasQuery = "Christmas"
        movieSearchService.searchMovies(withQuery: christmasQuery) { [weak self] (movies, error) in
            if let error = error {
                print("Error loading Christmas movies: \(error.localizedDescription)")
                return
            }
            if let movies = movies {
                self?.movies = movies // update massiv
                DispatchQueue.main.async {
                    self?.tableView.reloadData() // reload table
                }
            }
        }
    }
    // constraints
    private func setupConstraints() {
        view.backgroundColor = .white
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        view.addSubview(tableView)
        view.addLayoutGuide(bottomMarginGuide)
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(searchButton.snp.leading).offset(-20)
        }
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(searchTextField).offset(0)
            make.trailing.equalTo(view).offset(-20)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(bottomMarginGuide.snp.top)
        }
        // нижняя граница
        bottomMarginGuide.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view)
            make.height.equalTo(90)
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
        loadChristmasMovies()
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
                self?.movies = movies // update massive
                DispatchQueue.main.async {
                    self?.tableView.reloadData() // update table
                }
            }
        }
    }
} // end
//MARK: - keyboard
extension HomeViewController {
    private func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap() {
        view.endEditing(true) // Закрываем клавиатуру
    }
}
//MARK: - UITextFieldDelegate
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // if tapped "Return" => search
        textField.resignFirstResponder()
        if let query = textField.text, !query.isEmpty {
            searchMovies(query: query)
        }
        return true
    }
}
//MARK: - UITableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    // высота
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    // кол-во
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    // содержимое
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }

        let movie = movies[indexPath.row]
        cell.configure(with: movie)

        return cell
    }
    // нажата
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        showMovieDetails(for: selectedMovie)
        tableView.deselectRow(at: indexPath, animated: true)

    }
    // открываем about
    private func showMovieDetails(for movie: Movie) {
        let movieDetailViewController = MovieDetailViewController(movie: movie)
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}
