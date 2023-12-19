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
    
    
    
    // MARK: - Properties
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your username"
        textField.borderStyle = .roundedRect
        return textField
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
        view.backgroundColor = .white
        setupTarget()
        setupConstraints()
    }
    // MARK: - Private Methods
    private func setupConstraints() {
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
    
    private func setupTarget() {
        registerButton.addTarget(self, action: #selector(registerDoneButtonTapped), for: .touchUpInside)
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

            // Сохраняем изменения в контексте
            do {
                try context.save()
                print("User saved successfully")

                // Печатаем данные пользователя после успешного сохранения
                if let username = newUser.username,
                   let email = newUser.email,
                   let password = newUser.password {
                    print("Saved User - Username: \(username), Email: \(email), Password: \(password)")
                }

                registerButton.setTitle("OK", for: .normal)
                registerButton.backgroundColor = .systemGreen
                registerButton.isEnabled = false

            } catch {
                print("Error saving user: \(error)")
            }
        }
    }

    
    
}
