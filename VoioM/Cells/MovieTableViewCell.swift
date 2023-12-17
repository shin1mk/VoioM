//
//  MovieTableViewCell.swift
//  VoioM
//
//  Created by SHIN MIKHAIL on 18.12.2023.
//

import UIKit
import SnapKit

class MovieTableViewCell: UITableViewCell {
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearLabel)
        contentView.addSubview(genreLabel)

        coverImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(contentView).inset(8)
            make.width.equalTo(80)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(8)
            make.leading.equalTo(coverImageView.snp.trailing).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
        }

        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
        }

        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
            make.bottom.equalTo(contentView).offset(-8)
        }
    }

    func configure(with movie: Movie) {
        titleLabel.text = "\(movie.trackName) by \(movie.artistName)"
        yearLabel.text = "Year: \(movie.releaseDate)"
        genreLabel.text = "Genre: \(movie.primaryGenreName)"
        
        // Загрузка изображения с использованием URL
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
}
