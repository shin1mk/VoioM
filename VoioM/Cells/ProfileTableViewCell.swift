//
//  ProfileTableViewCell.swift
//  VoioM
//
//  Created by SHIN MIKHAIL on 19.12.2023.
//

import UIKit
import SnapKit

final class ProfileTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ProfileTableViewCell"
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    public let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        return label
    }()
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }
    // MARK: - Private Methods
    private func setupConstraints() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(8)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.bottom.equalTo(contentView).offset(-8)
        }
    }
}
