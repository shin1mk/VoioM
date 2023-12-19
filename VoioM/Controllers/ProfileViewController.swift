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
    // MARK: - Properties
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.reuseIdentifier)
        
        return tableView
    }()
    // Массив для хранения данных пользователя
    private var userData: [(title: String, value: String)] = []
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupConstraints()
        setupLogoutButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUserData()
    }
    // MARK: - Private Methods
    private func setupConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
                    ("Имя", currentUser.username ?? ""),
                    ("Логин", currentUser.email ?? ""),
                ]
                tableView.reloadData()
                print("Username: \(currentUser.username ?? "No username")")
                print("Email: \(currentUser.email ?? "No email")")
            }
        } catch {
            print("Error fetching user: \(error)")
        }
    }
    
    @objc private func logoutButtonTapped() {
        clearUserData()
        navigateToLoginScreen()
        deleteAllFavoriteMovies()
        print("Logout button tapped")
    }
    
    private func setupLogoutButton() {
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Выйти", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoutButton)
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
        // Очистите данные в массиве userData
        userData = []
        // Перезагрузите таблицу, чтобы отразить изменения
        tableView.reloadData()
    }
    // удаляем все статьи
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
}
