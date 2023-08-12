//
//  LoginController.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 23/7/23.
//

import UIKit

protocol AuthenticationDelegate: AnyObject {
    func authenticationDidComplete()
}

class LoginController: UIViewController {
    
    
    weak var delegate: AuthenticationDelegate?
    
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
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(handleForgetPassword), for: .touchUpInside)
        return button
    }()
    
    private var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObserver()
    }
    
    @objc func handleLogin() {
        guard let email = viewModel.email else { return }
        guard let pass = viewModel.password else { return }
        AuthService.userLogin(with: email, password: pass) { result, error in
            
            if let error = error {
                print("Error while login error: \(error.localizedDescription)")
            }
            self.delegate?.authenticationDidComplete()
        }
    }
    
    @objc func handleShowSignUp() {
        let controller = RegistrationController()
        controller.registrationDelegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleForgetPassword() {
        let controller = ResetPasswordViewController()
        controller.delegate = self
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
    
    func configureNotificationObserver() {
        emailTextField.addTarget(self, action: #selector(didTextChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didTextChange), for: .editingChanged)
    }
    
    @objc func didTextChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }
        else {
            viewModel.password = sender.text
        }
       updateForm()
    }
}

extension LoginController: FormViewModel {
    func updateForm() {
        loginButton.backgroundColor = viewModel.buttonBackgroudColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        loginButton.isEnabled = viewModel.isFormValid
    }
}

extension LoginController: ResetPasswordViewControllerDelegate {
    
    func controllerDidSendPasswordLink(_ controller: ResetPasswordViewController) {
        navigationController?.popViewController(animated: true)
        showMessage(withTitle: "Success", message: "We sent a link to your email to reset your password")
    }
}
