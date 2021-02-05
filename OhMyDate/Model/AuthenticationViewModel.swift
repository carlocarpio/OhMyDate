//
//  AuthenticationViewModel.swift
//  OhMyDate
//
//  Created by Carlo Carpio on 2/3/21.
//

import UIKit

//MARK: LoginViewModel

protocol FormViewModel {
    func updateForm()
}

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
    var shouldEnableButton: Bool { get }
    var buttonColor: UIColor { get }
    var buttonBackgroundColor: UIColor { get }
}

struct LoginViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var shouldEnableButton: Bool {
        return formIsValid
    }
    
    var buttonColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    
    var buttonBackgroundColor: UIColor {
        let enabledColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        let disabledColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        return formIsValid ? enabledColor : disabledColor
    }
}

//MARK: RegistrationViewModel

struct RegistrationViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    var fullname: String?
    
    var formIsValid: Bool {
        return
            email?.isEmpty == false &&
            password?.isEmpty == false &&
            fullname?.isEmpty == false
    }
    
    var shouldEnableButton: Bool {
        return formIsValid
    }
    
    var buttonColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    
    var buttonBackgroundColor: UIColor {
        let enabledColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        let disabledColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        return formIsValid ? enabledColor : disabledColor
    }
}

//MARK: ResetPasswordViewModel

struct ResetPasswordViewModel: AuthenticationViewModel {
    var email: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
    }
    
    var shouldEnableButton: Bool {
        return formIsValid
    }
    
    var buttonColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    
    var buttonBackgroundColor: UIColor {
        let enabledColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        let disabledColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        return formIsValid ? enabledColor : disabledColor
    }
}


