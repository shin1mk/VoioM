//
//  ProfileViewController.swift
//  VoioM
//
//  Created by SHIN MIKHAIL on 17.12.2023.
//

import UIKit
import CoreData
import SnapKit

final class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
        view.backgroundColor = .systemGreen
        setupTableView()
        setupLogoutButton()
        // Получаем данные о пользователе из CoreData
        fetchUserData()
    }
    // MARK: - Private Methods
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupLogoutButton() {
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Выйти", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoutButton)
    }
    
    private func fetchUserData() {
        // Получаем доступ к контексту CoreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext

        // Создаем запрос к CoreData для получения данных о текущем пользователе
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()

        do {
            let users = try context.fetch(fetchRequest)

            // Предполагается, что в приложении всегда будет только один пользователь, иначе вам нужно выбрать нужного пользователя
            if let currentUser = users.first {
                // Принудительно загружаем свойства пользователя
                currentUser.willAccessValue(forKey: nil) // Принудительный доступ ко всем свойствам
                userData = [
                    ("Имя", currentUser.username ?? ""),
                    ("Логин", currentUser.email ?? ""),
                    // Пароль не включаем
                ]


                // Обновляем отображение таблицы с новыми данными
                tableView.reloadData()

                // Добавим принты для проверки данных
                print("Username: \(currentUser.username ?? "No username")")
                print("Email: \(currentUser.email ?? "No email")")
            }
        } catch {
            print("Error fetching user: \(error)")
        }
    }

    @objc private func logoutButtonTapped() {
        // Добавьте код для выхода из учетной записи

        // Например, удаление данных о текущем пользователе
        clearUserData()

        // Переход на экран LoginViewController
        navigateToLoginScreen()
    }

    private func clearUserData() {
        // Ваш код для удаления данных о текущем пользователе
    }

    private func navigateToLoginScreen() {
        // Вариант 1: Если вы используете навигационный контроллер
        // navigationController?.popToRootViewController(animated: true)

        // Вариант 2: Если вы хотите модальный переход (без навигационного контроллера)
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .fullScreen
        present(loginViewController, animated: true, completion: nil)
    }

    // MARK: - UITableViewDataSource
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
