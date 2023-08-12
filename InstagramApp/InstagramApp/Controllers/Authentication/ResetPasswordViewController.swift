//
//  ResetPasswordViewController.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 13/8/23.
//

import UIKit

protocol ResetPasswordViewControllerDelegate : AnyObject {
    func controllerDidSendPasswordLink(_ controller: ResetPasswordViewController)
}

class ResetPasswordViewController: UIViewController {
    
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private var viewModel = ResetPasswordViewModel()
    
    weak var delegate: ResetPasswordViewControllerDelegate?
    
    private let iconImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(imageLiteralResourceName: "Instagram_logo_white"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Reset Password", for: .normal)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleResetPass), for: .touchUpInside)
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    func configureUI() {
        //view.backgroundColor = .gray
        configureGradientLayer()
        view.addSubview(backButton)
        backButton.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            paddingTop: 16,
            paddingLeft: 16
        )
        
        emailTextField.addTarget(self, action: #selector(didTextChange), for: .editingChanged)
        
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            paddingTop: 32
        )
        
        let stackView = UIStackView(
            arrangedSubviews: [emailTextField,  resetPasswordButton])
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
    }
    
    @objc func handleResetPass() {
        guard let  email = emailTextField.text else { return }
        showLoader(true)
        AuthService.resetPassword(withEmail: email) {
            error in
            
            if let error = error {
                print("Reseting password error: \(error.localizedDescription)")
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
                self.showLoader(false)
                return
            }
            
            self.delegate?.controllerDidSendPasswordLink(self)
            
        }
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTextChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }
       updateForm()
    }
    
}

extension ResetPasswordViewController: FormViewModel {
    func updateForm() {
        resetPasswordButton.backgroundColor = viewModel.buttonBackgroudColor
        resetPasswordButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        resetPasswordButton.isEnabled = viewModel.isFormValid
    }
}
