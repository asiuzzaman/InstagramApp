//
//  AuthenticationViewModel.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 23/7/23.
//

import UIKit

protocol AuthenticationViewModel {
    var isFormValid : Bool { get }
    var buttonBackgroudColor: UIColor { get }
    var buttonTitleColor: UIColor { get }
}

protocol FormViewModel {
    func updateForm()
}

struct LoginViewModel {
    var email: String?
    var password: String?
    
    var isFormValid : Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgroudColor: UIColor {
        return isFormValid ? .purple : .gray
    }
    
    var buttonTitleColor: UIColor {
        return isFormValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
}

struct RegistrationViewModel : AuthenticationViewModel {
    
    var email: String?
    var password: String?
    var fullName: String?
    var userName: String?

    var isFormValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && fullName?.isEmpty == false && userName?.isEmpty == false
    }
    
    var buttonBackgroudColor: UIColor {
        return isFormValid ? .purple : .gray
    }
    
    var buttonTitleColor: UIColor {
        return isFormValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
}
