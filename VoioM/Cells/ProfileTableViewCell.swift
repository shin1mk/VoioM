//
//  ProfileTableViewCell.swift
//  VoioM
//
//  Created by SHIN MIKHAIL on 19.12.2023.
//

import UIKit
import SnapKit

class ProfileTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ProfileTableViewCell"

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()

    let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()

    // Дополнительные свойства, если нужно
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
        setupConstraints()
    }

    // MARK: - Private Methods
    
    private func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        
        // Добавьте дополнительные свойства, если нужно
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(8)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }

        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.bottom.equalTo(contentView).offset(-8)
        }

        // Добавьте констрейнты для дополнительных свойств, если нужно
    }
}
