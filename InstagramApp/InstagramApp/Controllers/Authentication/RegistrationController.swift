//
//  RegistrationController.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 23/7/23.
//

import UIKit

class RegistrationController: UIViewController {
    
    
    private let plusPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleProfilePictureSelect), for: .touchUpInside)
        return button
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
    
    private let fullNameTextField = CustomTextField(placeholder: "FullName")
    private let userNameTextField = CustomTextField(placeholder: "UserName")
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("SignUp", for: .normal)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    
    private let alreadyHaveAccountButton: UIButton = {
       let button = UIButton()
        button.attributedTitle(firstPart: "Already have account", secondPart: "Login")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    private var profileImage = UIImage()
    private var viewModel = RegistrationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObserver()
    }
    
    @objc func handleShowSignUp() {
        
        guard let email = viewModel.email else { return }
        guard let pass = viewModel.password else { return }
        guard let userName = viewModel.userName else { return }
        guard let fullName = viewModel.fullName else { return }
        
        AuthService.registerUser(
            withCredentials: AuthCredentials(
                email: email,
                password: pass,
                userName: userName,
                fullName: fullName,
                profileImage: profileImage
            )
        )
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleProfilePictureSelect() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func configureUI() {
        configureGradientLayer()
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.setDimensions(height: 140, width: 140)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stackView = UIStackView(
            arrangedSubviews: [emailTextField, passwordTextField, fullNameTextField, userNameTextField, signupButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        view.addSubview(stackView)
        stackView.anchor(
            top: plusPhotoButton.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 32,
            paddingLeft: 32,
            paddingRight: 32
        )
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        alreadyHaveAccountButton.centerX(inView: view)
    }
    
    func configureNotificationObserver() {
        emailTextField.addTarget(self, action: #selector(didTextChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didTextChange), for: .editingChanged)
        
        userNameTextField.addTarget(self, action: #selector(didTextChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(didTextChange), for: .editingChanged)
    }
    
    @objc func didTextChange(sender: UITextField) {
        switch sender {
        case emailTextField:
            //print("[emailTextField] \(String(describing: sender.text))")
            viewModel.email = emailTextField.text
        case passwordTextField:
            //print("[passwordTextField] \(String(describing: sender.text))")
            viewModel.password = passwordTextField.text
        case userNameTextField:
            //print("[userNameTextField] \(String(describing: sender.text))")
            viewModel.userName = userNameTextField.text
        case fullNameTextField:
            //print("[fullNameTextField] \(String(describing: sender.text))")
            viewModel.fullName = fullNameTextField.text
        default:
            print("[Registration] unknown field ")
        }
        
        updateForm()
        
    }
    
}

extension RegistrationController: FormViewModel {
    func updateForm() {
        signupButton.backgroundColor = viewModel.buttonBackgroudColor
        signupButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        signupButton.isEnabled = viewModel.isFormValid
    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else {
            print("Image couldn't be selected")
            return
        }
        
        profileImage = selectedImage
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 2
        plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        self.dismiss(animated: true, completion: nil)
     }
    
}
