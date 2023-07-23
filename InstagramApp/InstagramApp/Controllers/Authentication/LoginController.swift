//
//  LoginController.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 23/7/23.
//

import UIKit

class LoginController: UIViewController {
    
    
    private let iconImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(imageLiteralResourceName: "Instagram_logo_white"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailTextField : CustomTextField = {
        let textField = CustomTextField(placeholder: "Email")
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    
    private let passwordTextField : CustomTextField = {
        let textField = CustomTextField(placeholder: "Password" )
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
       let button = UIButton()
        button.attributedTitle(firstPart: "Don't have account?", secondPart: "SignUp")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    private let forgetPasswordButton: UIButton = {
       let button = UIButton()
        button.attributedTitle(firstPart: "Forget you pass? ", secondPart: "Get into sign in.")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    @objc func handleShowSignUp() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
       
        configureGradientLayer()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            paddingTop: 32
        )
        
        let stackView = UIStackView(
            arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgetPasswordButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        view.addSubview(stackView)
        stackView.anchor(
            top: iconImage.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 32,
            paddingLeft: 32,
            paddingRight: 32
        )
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        dontHaveAccountButton.centerX(inView: view)
        
    }
}
