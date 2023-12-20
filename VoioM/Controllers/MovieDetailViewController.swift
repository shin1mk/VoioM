//
//  MovieDetailViewController.swift
//  VoioM
//
//  Created by SHIN MIKHAIL on 18.12.2023.
//

import UIKit
import SnapKit
import CoreData

final class MovieDetailViewController: UIViewController {
    private let movie: Movie?
    private let favoriteMovie: FavoriteMovie?
    //MARK: Properties
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        return textView
    }()
    private lazy var shareButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        return button
    }()
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    // Общий инициализатор для Movie и FavoriteMovie
//    init(movie: Movie? = nil, favoriteMovie: FavoriteMovie? = nil) {
//        self.movie = movie
//        self.favoriteMovie = favoriteMovie
//        super.init(nibName: nil, bundle: nil)
//    }
    init(movie: Movie? = nil, favoriteMovie: FavoriteMovie? = nil) {
        if let movie = movie {
            self.movie = movie
        } else if let favoriteMovie = favoriteMovie {
            self.movie = Movie(trackName: favoriteMovie.trackName!,
                               artistName: favoriteMovie.artistName!,
                               artworkUrl100: favoriteMovie.artworkUrl100!,
                               releaseDate: favoriteMovie.releaseDate!,
                               primaryGenreName: favoriteMovie.primaryGenreName!,
                               longDescription: favoriteMovie.longDescription)
        } else {
            self.movie = nil
            print("Warning: Both 'movie' and 'favoriteMovie' are nil in MovieDetailViewController.")
        }
        self.favoriteMovie = favoriteMovie
        super.init(nibName: nil, bundle: nil)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setMovieTitle()
        setupUI()
        setupTarget()
        populateUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isFavorite = isMovieAlreadySaved()
        updateFavoriteButton()
    }
    // title 25 символов
    private func setMovieTitle() {
        if let unwrappedMovie = movie {
            let truncatedTitle = String(unwrappedMovie.trackName.prefix(25))
            title = truncatedTitle
        }
    }
    // constraints
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(coverImageView)
        view.addSubview(titleLabel)
        view.addSubview(releaseDateLabel)
        view.addSubview(genreLabel)
        view.addSubview(descriptionTextView)
        // shareButton in navbar
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: favoriteButton), shareButton]
        
        coverImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.leading.equalTo(view).offset(15)
            make.width.equalTo(150)
            make.height.equalTo(200)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.top)
            make.leading.equalTo(coverImageView.snp.trailing).offset(10)
            make.trailing.equalTo(view).inset(15)
        }
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(view).inset(15)
        }
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(releaseDateLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(view).inset(15)
        }
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(view).inset(15)
        }
    }
    // load data
    private func populateUI() {
        // if from homeVC
        if let movie = movie {
            titleLabel.text = movie.trackName
            releaseDateLabel.text = "Release Date: \(movie.releaseDate)"
            genreLabel.text = "Genre: \(movie.primaryGenreName)"
            descriptionTextView.text = "\(movie.longDescription ?? "No description available.")"
            
            if let url = URL(string: movie.artworkUrl100) {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.coverImageView.image = image
                        }
                    }
                }.resume()
            }
            // if from favorite vc
        } else if let favoriteMovie = favoriteMovie {
            titleLabel.text = favoriteMovie.trackName
            releaseDateLabel.text = "Release Date: \(favoriteMovie.releaseDate ?? "")"
            genreLabel.text = "Genre: \(favoriteMovie.primaryGenreName ?? "")"
            descriptionTextView.text = "\(favoriteMovie.longDescription ?? "No description available.")"
            
            if let imageData = favoriteMovie.imageData {
                coverImageView.image = UIImage(data: imageData)
            }
        }
    }
    // target
    private func setupTarget() {
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    // share
    @objc private func shareButtonTapped() {
        let shareText = "I'm watching \(movie!.trackName) in the VoioM app!"
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    var isFavorite: Bool = false {
        didSet {
            updateFavoriteButton()
        }
    }
} // end
extension MovieDetailViewController {
    //MARK: Favorites
    // update the appearance of the favorite button
    private func updateFavoriteButton() {
        let imageName = isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    // favorite button
    @objc private func favoriteButtonTapped() {
        print("Favorite button tapped")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        _ = appDelegate.persistentContainer.viewContext
        
        if isMovieAlreadySaved() {
            // Фильм уже сохранен, удаляем его из Core Data
            deleteMovieFromCoreData()
        } else {
            // Фильм не сохранен, добавляем его в Core Data
            saveMovieToCoreData()
        }
    }
    // save in coreData
    private func saveMovieToCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        if let favoriteMovie = NSEntityDescription.insertNewObject(forEntityName: "FavoriteMovie", into: context) as? FavoriteMovie {
            favoriteMovie.trackName = movie?.trackName
            favoriteMovie.artistName = movie?.artistName
            favoriteMovie.artworkUrl100 = movie?.artworkUrl100
            favoriteMovie.releaseDate = movie?.releaseDate
            favoriteMovie.primaryGenreName = movie?.primaryGenreName
            favoriteMovie.longDescription = movie?.longDescription
            // Преобразовываем изображение в Data
            if let imageData = coverImageView.image?.pngData() {
                favoriteMovie.imageData = imageData
            }
            
            do {
                try context.save()
                isFavorite = true
                updateFavoriteButton()
                
                print("Movie saved to Core Data:")
                print("Track Name: \(favoriteMovie.trackName ?? "")")
                print("Artist Name: \(favoriteMovie.artistName ?? "")")
                print("Artwork URL: \(favoriteMovie.artworkUrl100 ?? "")")
                print("Release Date: \(favoriteMovie.releaseDate ?? "")")
                print("Genre: \(favoriteMovie.primaryGenreName ?? "")")
                print("Description: \(favoriteMovie.longDescription ?? "")")
            } catch let error as NSError {
                print("Could not save movie to Core Data. \(error), \(error.userInfo)")
            }
        }
    }
    // check if the movie is in favorites
    private func isMovieAlreadySaved() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteMovie")
        if let movie = movie {
            fetchRequest.predicate = NSPredicate(format: "trackName == %@", movie.trackName)
        } else {
            print("Warning: 'movie' is nil in the FavoritesViewController.")
        }
        do {
            let results = try context.fetch(fetchRequest)
            return !results.isEmpty
        } catch let error as NSError {
            print("Error checking if movie is already saved: \(error), \(error.userInfo)")
            return false
        }
    }
    // delete from coreData
//    private func deleteMovieFromCoreData() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        let context = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteMovie")
//        
//        if let unwrappedMovie = movie {
//            fetchRequest.predicate = NSPredicate(format: "trackName == %@", unwrappedMovie.trackName)
//        } else {
//            print("Warning: 'movie' is nil in the FavoritesViewController.")
//        }
//        do {
//            let results = try context.fetch(fetchRequest)
//            if let favoriteMovie = results.first as? NSManagedObject {
//                context.delete(favoriteMovie)
//                try context.save()
//                isFavorite = false
//                updateFavoriteButton()
//                print("Movie deleted from Core Data")
//                
//                navigationController?.popViewController(animated: true) // назад на экран
//            }
//        } catch let error as NSError {
//            print("Error deleting movie from Core Data: \(error), \(error.userInfo)")
//        }
//    }
    private func deleteMovieFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteMovie")
        
        if let unwrappedMovie = movie {
            fetchRequest.predicate = NSPredicate(format: "trackName == %@ AND artistName == %@", unwrappedMovie.trackName, unwrappedMovie.artistName)
        } else {
            print("Warning: 'movie' is nil in the FavoritesViewController.")
            return
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            if let favoriteMovie = results.first as? NSManagedObject {
                context.delete(favoriteMovie)
                try context.save()
                isFavorite = false
                updateFavoriteButton()
                print("Movie deleted from Core Data")
                
//                navigationController?.popViewController(animated: true) // назад на экран
            }
        } catch let error as NSError {
            print("Error deleting movie from Core Data: \(error), \(error.userInfo)")
        }
    }

    
//    private func deleteMovieFromCoreData() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//
//        let context = appDelegate.persistentContainer.viewContext
//
//        if let favoriteMovieToDelete = favoriteMovie {
//            context.delete(favoriteMovieToDelete)
//
//            do {
//                try context.save()
//                isFavorite = false
//                updateFavoriteButton()
//                print("Movie deleted from Core Data")
//
//                navigationController?.popViewController(animated: true) // назад на экран
//            } catch let error as NSError {
//                print("Error deleting movie from Core Data: \(error), \(error.userInfo)")
//            }
//        }
//    }

}
