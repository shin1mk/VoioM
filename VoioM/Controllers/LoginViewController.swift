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
        checkUserLoginStatus()
    }
    // вошел в аккаунт или нет
    private func checkUserLoginStatus() {
        if isUserLoggedIn() {
            showMainTabViewController()
        } else {
            setupConstraints()
            setupTarget()
            setupDelegate()
        }
    }
    // вошел ли ранее пользователь?
    private func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    }
    // save log
    private func setLoggedIn() {
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
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
    //Constraints
    private func setupConstraints() {
        view.backgroundColor = .white
        view.addSubview(infoButton)
        infoButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.leading.equalTo(view).offset(20)
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
    // info button
    @objc private func infoButtonTapped() {
        let alert = UIAlertController(title: "Enter this data 😎",
                                      message: "email: 123@gmail.com \npassword: qwerty",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    // login button
    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlertError(message: "Please enter email and password.")
            return
        }
        if email == "123@gmail.com" && password == "qwerty" {
            // Успешный вход
            setLoggedIn()
            print("login done")
            showMainTabViewController()
        } else {
            showAlertError(message: "Invalid email or password.")
        }
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
        let alert = UIAlertController(title: "Register",
                                      message: "not available 🥲",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
            
            animateTransition(to: mainTabBarController, in: window)
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
            let maxLength = 20
            let currentString = textField.text ?? ""
            let newLength = currentString.count + string.count - range.length
            return newLength <= maxLength
        }
        if textField == passwordTextField {
            let maxLength = 20
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
