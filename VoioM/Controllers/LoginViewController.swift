//
//
//  LoginViewController.swift
//  VoioM
//
//  Created by SHIN MIKHAIL on 17.12.2023.
//

import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    //MARK: Properties
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your e-mail"
        textField.borderStyle = .roundedRect
        return textField
    }()
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
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
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserLoginStatus()
    }
    // вошел в аккаунт или нет
    private func checkUserLoginStatus() {
        if isUserLoggedIn() {
            // Если пользователь уже вошел, открываем MainTabBarController
            showMainTabViewController()
        } else {
            // Если пользователь не вошел, показываем экран ввода данных
            setupConstraints()
            setupTarget()
        }
    }
    // вошел ли ранее пользователь?
    private func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    }
    
    private func setLoggedIn() {
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
    }
    // targets
    private func setupTarget() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    //Constraints
    private func setupConstraints() {
        view.backgroundColor = .white
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
    // login button
    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlertError(message: "Please enter email and password.")
            return
        }
        if email == "1@gmail.com" && password == "qwerty" {
            // Успешный вход
            setLoggedIn()
            print("okay")
            showMainTabViewController()
        } else {
            showAlertError(message: "Invalid email or password.")
        }
    }
    //error alert
    private func showAlertError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    // register button
    @objc private func registerButtonTapped() {
        let alert = UIAlertController(title: "Введи эти данные", 
                                      message: "email: 1@gmail.com \npassword: qwerty",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func showMainTabViewController() {
        let mainTabBarController = MainTabBarController()

        // Здесь вы можете создать и добавить ваши вкладки (Tab) к mainTabBarController

        // Пример:
        let firstViewController = UIViewController()
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)

        let secondViewController = UIViewController()
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)

        mainTabBarController.setViewControllers([firstViewController, secondViewController], animated: false)

        // Переключимся на главный UITabBarController
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let windowDelegate = windowScene.delegate as? SceneDelegate,
           let window = windowDelegate.window {
            window.rootViewController = mainTabBarController
        }
    }
} // end
