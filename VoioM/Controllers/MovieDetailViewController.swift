//
//  MovieDetailViewController.swift
//  VoioM
//
//  Created by SHIN MIKHAIL on 18.12.2023.
//

import UIKit
import SnapKit

final class MovieDetailViewController: UIViewController {
    private let movie: Movie
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
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    // init
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    private var isFavorite: Bool = false {
        didSet {
            updateFavoriteButton()
        }
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
        checkFavoriteStatus()
    }
    // title 25 символов
    private func setMovieTitle() {
        let truncatedTitle = String(movie.trackName.prefix(25))
        title = truncatedTitle
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
    }
    // target
    private func setupTarget() {
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    // share
    @objc private func shareButtonTapped() {
        let shareText = "I'm watching \(movie.trackName) in the VoioM app!"
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
} // end
extension MovieDetailViewController {
    //MARK: Favorites
    // check if the movie is in favorites
    private func checkFavoriteStatus() {
        // Ваша логика проверки, например, можно использовать UserDefaults или CoreData
        // Пример: isFavorite = FavoritesManager.isMovieInFavorites(movie)
    }
    // update the appearance of the favorite button
    private func updateFavoriteButton() {
        let imageName = isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    // handle favorite button tap
    @objc private func favoriteButtonTapped() {
        print("Favorite button tapped")
        isFavorite.toggle()
    }
}
