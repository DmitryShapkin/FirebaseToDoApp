//
//  LoginViewController.swift
//  ToDoFIRE
//
//  Created by Dmitry Shapkin on 14/12/2019.
//  Copyright © 2019 ShapkinDev. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
//    var handle: AuthStateDidChangeListenerHandle?
    var ref: DatabaseReference!
    
    /// Лэйбл заголовка
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ToDoFire"
        label.font = UIFont(name: "Thonburi-Bold", size: 40)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Лэйбл ошибки
    let warnLabel: UILabel = {
        let label = UILabel()
        label.text = "User does not exist"
        label.font = UIFont(name: "Thonburi", size: 20)
        label.textColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()
    
    /// Текстовое поле E-mail
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-mail"
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    /// Текстовое поле Password
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    /// Кнопка Login
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()
    
    /// Кнопка Register
    let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        ref = Database.database().reference(withPath: "users")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
//            guard let self = self else { return }
//
//            if user != nil {
////                let taskViewController = TasksViewController()
////                self?.navigationController?.pushViewController(taskViewController, animated: true)
////                return
//                self.loginTapped()
//            }
//        }
        
//        emailTextField.text = ""
//        passwordTextField.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        Auth.auth().removeStateDidChangeListener(handle!)
    }
}

private extension LoginViewController {
    
    func setupLayout() {
        self.view.backgroundColor = .orange
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(warnLabel)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            warnLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            warnLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            warnLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            emailTextField.topAnchor.constraint(equalTo: warnLabel.bottomAnchor, constant: 80),
            emailTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
            
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            registerButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            registerButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50)
        ])
    }
    
    @objc
    func loginTapped() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        
        /// Логинимся в Firebase
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            guard let self = self else { return }
            
            if error != nil {
                self.displayWarningLabel(withText: "Error occured")
                return
            }
            
            if user != nil {
                let taskViewController = TasksViewController()
                self.navigationController?.pushViewController(taskViewController, animated: true)
                return
            }
            self.displayWarningLabel(withText: "No such user")
        }
    }
    
    @objc
    func registerTapped() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            
            guard let self = self else { return }
            guard error == nil, user != nil else {
                print(error?.localizedDescription)
                return
            }
            
            // Cохраним email пользователя в БД
            let userRef = self.ref.child((user?.user.uid)!)
            userRef.setValue(["email": user?.user.email])
        }
    }
    
    func displayWarningLabel(withText text: String) {
        warnLabel.text = text
        UIView.animate(withDuration: 3,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: [.curveEaseInOut],
                       animations: { [weak self] in
                        guard let self = self else { return }
                        self.warnLabel.alpha = 1
        }) { [weak self] complete in
            guard let self = self else { return }
            self.warnLabel.alpha = 0
        }
    }
}


// MARK: - Спрятать/Показать клавиатуру

private extension LoginViewController {
    
    @objc
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
