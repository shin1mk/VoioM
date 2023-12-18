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
    // init
    init(movie: Movie) {
        self.movie = movie
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
        populateUI()
    }
    // title 30 символов
    private func setMovieTitle() {
        let truncatedTitle = String(movie.trackName.prefix(30))
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
} // end 