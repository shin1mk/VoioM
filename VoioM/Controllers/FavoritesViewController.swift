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
    private let emptyFavoritesLabel: UILabel = {
        let label = UILabel()
        label.text = "No favorite movies"
        label.textAlignment = .center
        label.textColor = .systemGray
        label.isHidden = true
        return label
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
        view.addSubview(emptyFavoritesLabel)
        emptyFavoritesLabel.snp.makeConstraints { make in
            make.center.equalTo(tableView)
        }
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
            // Show/hide emptyFavoritesLabel
            emptyFavoritesLabel.isHidden = !favoriteMovies.isEmpty
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    // удаления статьи из избранного
    private func deleteFavoriteMovie(at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let favoriteMovie = favoriteMovies[indexPath.row]
        
        context.delete(favoriteMovie)
        
        do {
            try context.save()
            favoriteMovies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            // Show/hide emptyFavoritesLabel
            emptyFavoritesLabel.isHidden = !favoriteMovies.isEmpty
        } catch let error as NSError {
            print("Error deleting movie: \(error), \(error.userInfo)")
        }
    }
}
//MARK: UITableView
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    // высота
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    // swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteFavoriteMovie(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        
        let favoriteMovie = favoriteMovies[indexPath.row]
        
        cell.titleLabel.text = "\(favoriteMovie.trackName!) by \(String(describing: favoriteMovie.artistName!))"
        cell.yearLabel.text = "Year: \(favoriteMovie.releaseDate ?? "")"
        cell.genreLabel.text = "Genre: \(favoriteMovie.primaryGenreName ?? "")"
        // изображениe
        if let imageData = favoriteMovie.imageData {
            cell.coverImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }
    // нажата
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFavoriteMovie = favoriteMovies[indexPath.row]
        showMovieDetails(for: selectedFavoriteMovie)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func showMovieDetails(for favoriteMovie: FavoriteMovie) {
        print("Selected Favorite Movie:")
        print("Track Name: \(favoriteMovie.trackName ?? "")")
        print("Artist Name: \(favoriteMovie.artistName ?? "")")
        print("Artwork URL: \(favoriteMovie.artworkUrl100 ?? "")")
        print("Release Date: \(favoriteMovie.releaseDate ?? "")")
        print("Genre: \(favoriteMovie.primaryGenreName ?? "")")
        print("Description: \(favoriteMovie.longDescription ?? "")")
        
        let movieDetailViewController = MovieDetailViewController(favoriteMovie: favoriteMovie)
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}
