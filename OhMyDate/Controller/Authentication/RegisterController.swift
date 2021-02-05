//
//  RegisterController.swift
//  OhMyDate
//
//  Created by Carlo Carpio on 1/31/21.
//

import UIKit
import Firebase

class RegisterController: UIViewController {
    
    private var viewModel = RegistrationViewModel()
    
    private let iconImage = UIImageView(image: #imageLiteral(resourceName: "firebase-logo"))
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullnameTextField = CustomTextField(placeholder: "Full Name")
    
    private let signupButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.title = "Sign up"
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return button
    }()

    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(
            string: "Already have an account? ",
            attributes: [
                .foregroundColor: UIColor(white: 1, alpha: 0.87),
                .font: UIFont.systemFont(ofSize: 16)
            ])
        attributedTitle.append(
            NSAttributedString(
                string: "Log in",
                attributes: [
                    .foregroundColor: UIColor(white: 1, alpha: 0.87),
                    .font: UIFont.boldSystemFont(ofSize: 16)
                ]))

        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(
            self,
            action: #selector(showLogin),
            for: .touchUpInside)

        return button
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureUI()
        configureNotificationObservers()
    }
    
    //MARK: Helpers
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        // Add gradient
        configureGradientBackground()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 120, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [
                                    emailTextField,
                                    passwordTextField,
                                    fullnameTextField,
                                    signupButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 32,
                     paddingLeft: 32,
                     paddingRight: 32)
        
       
        
      
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            paddingBottom: 10)
    }

    func configureNotificationObservers() {
        emailTextField.addTarget(self, action:#selector(textDidChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action:#selector(textDidChanged), for: .editingChanged)
        fullnameTextField.addTarget(self, action:#selector(textDidChanged), for: .editingChanged)
    }
    
    // MARK: Selectors
    
    @objc func textDidChanged(_ sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == fullnameTextField {
            viewModel.fullname = sender.text
        }  else {
            viewModel.password = sender.text
        }
        
        updateForm()
    }
    
    @objc func handleSignup() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        
        Service.registerUserWithFirebase(withEmail: email, password: password, fullname: fullname) { (error, ref) in
            if let error = error {
               print("DEBUG: Error signing up.... \(error.localizedDescription)")
               return
            }

            print("Debug: Successfuly signed up.")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func showLogin() {
        navigationController?.popViewController(animated: true)
    }

}

//MARK: FormViewModel

extension RegisterController: FormViewModel {
    func updateForm() {
        signupButton.isEnabled = viewModel.shouldEnableButton
        signupButton.backgroundColor = viewModel.buttonBackgroundColor
        signupButton.setTitleColor(viewModel.buttonColor, for: .normal)
    }
}
