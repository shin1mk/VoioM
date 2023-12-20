//
//  RegistrationViewController.swift
//  VoioM
//
//  Created by SHIN MIKHAIL on 19.12.2023.
//

import UIKit
import SnapKit
import CoreData

final class RegistrationViewController: UIViewController {
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create account"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your username (max 25 characters)"
        textField.borderStyle = .roundedRect
        return textField
    }()
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your e-mail (max 25 characters, ends with @gmail.com)"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        return textField
    }()
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your password"
        //        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        return textField
    }()
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5.0
        return button
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTarget()
        setupDelegate()
        setupConstraints()
    }
    // MARK: - Private Methods
    private func setupConstraints() {
        view.backgroundColor = .white
        navigationItem.titleView = titleLabel

        view.addSubview(usernameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)

        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(usernameTextField)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(usernameTextField)
        }
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(usernameTextField)
        }
    }
    // target
    private func setupTarget() {
        registerButton.addTarget(self, action: #selector(registerDoneButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    // MARK: - Actions
    @objc private func registerDoneButtonTapped() {
        print("Registration button tapped")
        // Получаем доступ к контексту CoreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        // Создаем новый объект User
        if let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            // Устанавливаем свойства объекта из текстовых полей
            newUser.username = usernameTextField.text
            newUser.email = emailTextField.text
            newUser.password = passwordTextField.text
            do {
                try context.save()
                print("User saved successfully")
                // prints
                if let username = newUser.username,
                   let email = newUser.email,
                   let password = newUser.password {
                    print("Saved User - Username: \(username), Email: \(email), Password: \(password)")
                }
                // Скрываем все вводные поля
                usernameTextField.isHidden = true
                emailTextField.isHidden = true
                passwordTextField.isHidden = true
                // button change color
                registerButton.setTitle("OK", for: .normal)
                registerButton.backgroundColor = .systemGreen
                registerButton.isEnabled = false
            } catch {
                print("Error saving user: \(error)")
            }
        }
    }
}
//extension RegistrationViewController: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == usernameTextField {
//            let maxLength = 25
//            let currentString = textField.text ?? ""
//            let newLength = currentString.count + string.count - range.length
//            return newLength <= maxLength
//        }
//        return true
//    }
//}
extension RegistrationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case usernameTextField:
            // Проверка для usernameTextField
            let maxLength = 25
            let currentString = textField.text ?? ""
            let newLength = currentString.count + string.count - range.length
            return newLength <= maxLength

        case emailTextField:
            // Проверка для emailTextField
            let maxLength = 25
            let currentString = textField.text ?? ""
            let newLength = currentString.count + string.count - range.length
            return newLength <= maxLength

        default:
            // Если не является ни usernameTextField, ни emailTextField, разрешаем ввод
            return true
        }
    }
}
