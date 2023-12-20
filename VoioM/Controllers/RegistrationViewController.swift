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
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your username"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "maximum 25 characters"
        textField.borderStyle = .roundedRect
        return textField
    }()
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your email"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "ends with @gmail.com"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        return textField
    }()
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your password"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "maximum 25 characters"
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
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 5.0
        button.isHidden = true
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
        
        view.addSubview(usernameLabel)
        view.addSubview(usernameTextField)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        view.addSubview(doneButton)
        //user name
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(0)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }
        // email
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(0)
            make.leading.trailing.height.equalTo(usernameTextField)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(0)
            make.leading.trailing.height.equalTo(usernameTextField)
        }
        // password
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(0)
            make.leading.trailing.height.equalTo(usernameTextField)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(0)
            make.leading.trailing.height.equalTo(usernameTextField)
        }
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(usernameTextField)
        }
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(usernameTextField)
        }
    }
    // target
    private func setupTarget() {
        registerButton.addTarget(self, action: #selector(registerDoneButtonTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    // MARK: - Actions
    @objc private func registerDoneButtonTapped() {
        // Получаем доступ к контексту CoreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        guard let username = usernameTextField.text, !username.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            // Вывести предупреждение о том, что все поля должны быть заполнены
            let alert = UIAlertController(title: "Incomplete Information",
                                          message: "Please fill in all fields.",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        // Создаем новый User
        if let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            // Устанавливаем свойства
            newUser.username = usernameTextField.text
            newUser.email = emailTextField.text
            newUser.password = passwordTextField.text
            // Добавляем проверку для префикса "@gmail.com"
            if let email = newUser.email, email.hasSuffix("@gmail.com"), email.count > "@gmail.com".count {
                do {
                    try context.save()
                    if let username = newUser.username, let email = newUser.email, let password = newUser.password {
                        print("Saved User - Username: \(username), Email: \(email), Password: \(password)")
                    }
                    animateButtonTransition()
                } catch {
                    print("Error saving user: \(error)")
                }
            } else {
                let alert = UIAlertController(title: "Invalid Email Format",
                                              message: "Please use an email address with the '@gmail.com' suffix.",
                                              preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    // animate
    private func animateButtonTransition() {
        // отключаем все вводные поля
        usernameTextField.isEnabled = false
        emailTextField.isEnabled = false
        passwordTextField.isEnabled = false
        
        UIView.animate(withDuration: 0.7) {
            self.usernameLabel.textColor = .systemGreen
            self.emailLabel.textColor = .systemGreen
            self.passwordLabel.textColor = .systemGreen
        }
        // Изменяем кнопку
        UIView.animate(withDuration: 0.5, animations: {
            self.registerButton.alpha = 0.0
            self.doneButton.alpha = 1.0
        }, completion: { _ in
            self.registerButton.isHidden = true
            self.doneButton.isHidden = false
        })
    }
    
    @objc private func doneButtonTapped() {
        navigationController?.popViewController(animated: true) // назад на экран
    }
}
// проверка длины ввода
extension RegistrationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 25
        let currentString = textField.text ?? ""
        let newLength = currentString.count + string.count - range.length
        
        switch textField {
        case usernameTextField, emailTextField, passwordTextField:
            return newLength <= maxLength
        default:
            return true
        }
    }
}
