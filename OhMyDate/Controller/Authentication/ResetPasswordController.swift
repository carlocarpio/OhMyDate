//
//  ResetPasswordController.swift
//  OhMyDate
//
//  Created by Carlo Carpio on 2/3/21.
//

import UIKit

class ResetPasswordController: UIViewController {
    
    private var viewModel = ResetPasswordViewModel()
    
    private let iconImage = UIImageView(image: #imageLiteral(resourceName: "firebase-logo"))
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private let resendButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.title = "Send Reset Link"
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    // MARK: Helpers
    func configureUI() {
        configureGradientBackground()
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 120, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, resendButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 32,
                     paddingLeft: 32,
                     paddingRight: 32)
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action:#selector(textDidChanged), for: .editingChanged)
    }
    
    //MARK: selectors
    
    @objc func textDidChanged(_ sender: UITextField) {
        viewModel.email = sender.text
        updateForm()
    }
    
    @objc func handleForgotPassword() {
        print("forgot password")
    }
    
    @objc func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: FormViewModel

extension ResetPasswordController: FormViewModel {
    func updateForm() {
        resendButton.isEnabled = viewModel.shouldEnableButton
        resendButton.backgroundColor = viewModel.buttonBackgroundColor
        resendButton.setTitleColor(viewModel.buttonColor, for: .normal)
    }
}
