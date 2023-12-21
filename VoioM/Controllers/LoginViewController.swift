//
//
//  LoginViewController.swift
//  VoioM
//
//  Created by SHIN MIKHAIL on 17.12.2023.
//

import UIKit
import SnapKit
import CoreData

final class LoginViewController: UIViewController {
    //MARK: Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your e-mail"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        return textField
    }()
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        return textField
    }()
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5.0
        return button
    }()
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5.0
        return button
    }()
    private let infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "questionmark.bubble"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupTarget()
        setupDelegate()
        checkUserLoginStatus()
    }
    // вошел в аккаунт или нет
    private func checkUserLoginStatus() {
        if isUserLoggedIn() {
            showMainTabViewController()
        } else {
            print("checkUserLoginStatus")
            navigateToLoginScreen()
        }
    }
    
    private func navigateToLoginScreen() {
        // Переход к корневому контроллеру
        navigationController?.popToRootViewController(animated: true)
    }
    // вошел ли ранее пользователь?
    private func isUserLoggedIn() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let users = try context.fetch(fetchRequest)
            return !users.isEmpty
        } catch {
            print("Error fetching users: \(error)")
            return false
        }
    }
    // targets
    private func setupTarget() {
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    // delegates
    private func setupDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    // Constraints
    private func setupConstraints() {
        view.backgroundColor = .white
        navigationItem.titleView = titleLabel
        view.addSubview(infoButton)
        infoButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(emailTextField)
        }
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(passwordTextField)
            make.height.equalTo(40)
        }
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.leading.trailing.equalTo(loginButton)
            make.height.equalTo(40)
        }
    }
    // Доп метод удаления всех юзеров из core data
    private func deleteAllUsers() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("All users deleted from Core Data.")
        } catch {
            print("Error deleting all users: \(error)")
        }
    }
    // info button
    @objc private func infoButtonTapped() {
        let alert = UIAlertController(title: "Register first 😎",
                                      message: "then enter your email and password",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    // login button
    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlertError(message: "Введите адрес электронной почты и пароль.")
            return
        }
        // Проверка формата электронной почты
        if !isValidEmail(email) {
            print("Неверный формат электронной почты.")
            showAlertError(message: "Неверный формат электронной почты. Пожалуйста, используйте адрес с суффиксом '@gmail.com'.")
            return
        }
        // Получение пользователя из CoreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Ошибка получения AppDelegate.")
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email ==[c] %@", email)

        do {
            let users = try context.fetch(fetchRequest)
            // Проверка наличия пользователя с email
            if let user = users.first {
                // Сравнение пароля
                if user.password == password {
                    // вход в систему
                    print("Вход выполнен")
                    showMainTabViewController()
                } else {
                    print("Неверный пароль.")
                    showAlertError(message: "Неверный пароль.")
                }
            } else {
                print("Пользователь с предоставленным адресом электронной почты не найден.")
                showAlertError(message: "Пользователь с предоставленным адресом электронной почты не найден.")
            }
        } catch {
            print("Ошибка при получении пользователя: \(error)")
            showAlertError(message: "Возникла ошибка при попытке входа в систему.")
        }
    }
    // Вспомогательный метод для проверки формата электронной почты
    private func isValidEmail(_ email: String) -> Bool {
        return email.hasSuffix("@gmail.com") && email.count > "@gmail.com".count
    }
    // error alert
    private func showAlertError(message: String) {
        let alert = UIAlertController(title: "Error 🤬",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    // register button
    @objc private func registerButtonTapped() {
        let registrationViewController = RegistrationViewController()
        navigationController?.pushViewController(registrationViewController, animated: true)
        deleteAllUsers()
    }
    //MARK: - show main tab vc
    private func showMainTabViewController() {
        let mainTabBarController = UITabBarController()
        
        let firstViewController = generateVC(
            viewController: HomeViewController(),
            title: "Home",
            image: UIImage(systemName: "house.fill"))
        
        let secondViewController = generateVC(
            viewController: FavoritesViewController(),
            title: "Favorites",
            image: UIImage(systemName: "star.fill"))
        
        let thirdViewController = generateVC(
            viewController: ProfileViewController(),
            title: "Profile",
            image: UIImage(systemName: "person.fill"))
        
        mainTabBarController.setViewControllers([firstViewController, secondViewController, thirdViewController], animated: false)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let windowDelegate = windowScene.delegate as? SceneDelegate,
           let window = windowDelegate.window {
            
            DispatchQueue.main.async {
                self.animateTransition(to: mainTabBarController, in: window)
            }
        }
    }
    // create vc
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        return navigationController
    }
    // animation
    private func animateTransition(to viewController: UIViewController, in window: UIWindow) {
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = viewController
        }, completion: nil)
    }
    
} // end
//MARK: - maxLength textField
extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTextField {
            let maxLength = 25
            let currentString = textField.text ?? ""
            let newLength = currentString.count + string.count - range.length
            return newLength <= maxLength
        }
        if textField == passwordTextField {
            let maxLength = 25
            let currentString = textField.text ?? ""
            let newLength = currentString.count + string.count - range.length
            return newLength <= maxLength
        }
        return true
    }
    // return swith to password.password swith to login
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            // Если вводится email, переходим к полю ввода пароля
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            // Если вводится пароль, переключаем на кнопку Login
            loginButtonTapped()
        }
        return true
    }
}
