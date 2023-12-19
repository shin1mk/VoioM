//
//  FavoritesViewController.swift
//  VoioM
//
//  Created by SHIN MIKHAIL on 17.12.2023.
//

import UIKit
import CoreData

final class FavoritesViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieCell")
        return tableView
    }()
    private let bottomMarginGuide = UILayoutGuide()
    private var favoriteMovies: [FavoriteMovie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupDelegates()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavoriteMovies()
    }
    
    private func setupConstraints() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addLayoutGuide(bottomMarginGuide)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(bottomMarginGuide.snp.top)
        }
        bottomMarginGuide.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view)
            make.height.equalTo(90)
        }
    }
    
    private func setupDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchFavoriteMovies() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
        
        do {
            favoriteMovies = try context.fetch(fetchRequest)
            tableView.reloadData()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
//MARK: UITableView
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    // высота
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        
        let favoriteMovie = favoriteMovies[indexPath.row]
        
        cell.titleLabel.text = "\(favoriteMovie.trackName!) by \(favoriteMovie.artistName!)"
        cell.yearLabel.text = "Year: \(favoriteMovie.releaseDate ?? "")"
        cell.genreLabel.text = "Genre: \(favoriteMovie.primaryGenreName ?? "")"
        // изображениe
        if let imageData = favoriteMovie.imageData {
            cell.coverImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }
    // нажата
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let selectedMovie = movies[indexPath.row]
    //        showMovieDetails(for: selectedMovie)
    //        tableView.deselectRow(at: indexPath, animated: true)
    //    }
    //    // открываем about
    //    private func showMovieDetails(for movie: Movie) {
    //        let movieDetailViewController = MovieDetailViewController(movie: movie)
    //        navigationController?.pushViewController(movieDetailViewController, animated: true)
    //    }
}
