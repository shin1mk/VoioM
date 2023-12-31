//
//  ProfileViewController.swift
//  VoioM
//
//  Created by SHIN MIKHAIL on 17.12.2023.
//

import UIKit
import CoreData
import SnapKit

final class ProfileViewController: UIViewController {
    // Массив для хранения данных пользователя
    private var userData: [(title: String, value: String)] = []
    // MARK: - Properties
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .systemBlue
        imageView.layer.cornerRadius = 50
        imageView.image = UIImage(named: "avatar")
        return imageView
    }()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.reuseIdentifier)
        return tableView
    }()
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log out and delete", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5.0
        return button
    }()
    private let bottomMarginView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTarget()
        setupDelegate()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUserData()
    }
    // MARK: - Private Methods
    private func setupConstraints() {
        tableView.backgroundColor = .white
        view.backgroundColor = .white

        view.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.width.height.equalTo(100)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(avatarImageView.snp.bottom).offset(0)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-60)
        }
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }
        view.addSubview(bottomMarginView)
        bottomMarginView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(10)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-5)
        }
    }
    // target
    private func setupTarget() {
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    // delegate
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func fetchUserData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        // Создаем запрос к CoreData для получения данных о текущем пользователе
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let users = try context.fetch(fetchRequest)
            // всегда один пользователь
            if let currentUser = users.first {
                currentUser.willAccessValue(forKey: nil) // доступ ко всем свойствам
                
                print("Fetched User - Username: \(currentUser.username ?? "No username"), Email: \(currentUser.email ?? "No email")")
                
                userData = [
                    ("Username", currentUser.username ?? ""),
                    ("Login", currentUser.email ?? ""),
                ]
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print("Username: \(currentUser.username ?? "No username")")
                print("Email: \(currentUser.email ?? "No email")")
            }
        } catch {
            print("Error fetching user: \(error)")
        }
    }
    
    @objc private func logoutButtonTapped() {
        logoutAlert()
    }
    
    private func logoutAlert() {
        let alert = UIAlertController(title: "Are you sure?",
                                      message: "Your profile and favorite movies will be deleted.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { _ in
            self.performLogout()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func performLogout() {
        DispatchQueue.main.async {
            self.clearUserData()
            self.deleteAllFavoriteMovies()
            self.navigateToLoginScreen()
        }
    }
    
    private func clearUserData() {
        // Получаем доступ к контексту CoreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        // Создаем запрос к CoreData для получения данных о текущем пользователе
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let users = try context.fetch(fetchRequest)
            // всегда один пользователь
            if let currentUser = users.first {
                // Удаляем текущего пользователя из контекста CoreData
                context.delete(currentUser)
                try context.save()
                print("User profile data cleared successfully.")
            }
        } catch {
            print("Error clearing user data: \(error)")
        }
        // Очистил данные в массиве userData
        userData = []

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    // удаляем все статьи после выхода
    private func deleteAllFavoriteMovies() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        
        do {
            let favoriteMovies = try context.fetch(fetchRequest)
            for movie in favoriteMovies {
                context.delete(movie)
            }
            
            try context.save()
            print("All favorite movies deleted successfully.")
        } catch let error as NSError {
            print("Error deleting all favorite movies: \(error), \(error.userInfo)")
        }
    }
    
    private func navigateToLoginScreen() {
        let loginViewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
// MARK: - UITableView
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.reuseIdentifier, for: indexPath) as! ProfileTableViewCell
        let data = userData[indexPath.row]
        
        cell.titleLabel.text = data.title
        cell.valueLabel.text = data.value
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
