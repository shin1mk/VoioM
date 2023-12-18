//
//  FavoritesViewController.swift
//  VoioM
//
//  Created by SHIN MIKHAIL on 17.12.2023.
//

import UIKit
import SnapKit

final class FavoritesViewController: UIViewController {
    //MARK: Properties
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
//        setupDelegates()
    }
    // constraints
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
    // delegates
//    private func setupDelegates() {
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
}
//MARK: UITableView
//extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
//
//        return cell
//    }
//}
