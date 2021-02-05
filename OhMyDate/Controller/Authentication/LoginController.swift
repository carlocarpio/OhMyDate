//
//  LoginController.swift
//  OhMyDate
//
//  Created by Carlo Carpio on 1/31/21.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import Firebase

class LoginController: UIViewController {

    private var viewModel = LoginViewModel()
    
    private let iconImage = UIImageView(image: #imageLiteral(resourceName: "firebase-logo"))
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.title = "Login"
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(
            string: "Forgot your password ",
            attributes: [
                .foregroundColor: UIColor(white: 1, alpha: 0.87),
                .font: UIFont.systemFont(ofSize: 15)
            ])
        attributedTitle.append(
            NSAttributedString(
                string: "Get Help Signing in.",
                attributes: [
                    .foregroundColor: UIColor(white: 1, alpha: 0.87),
                    .font: UIFont.boldSystemFont(ofSize: 15)
                ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(
            self,
            action: #selector(showForgotPassword),
            for: .touchUpInside)
        
        return button
    }()
    
    private let dividerView = DividerView()
    
    private let googleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "btn_google_light_pressed_ios").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle(" Login with Google", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
        return button
    }()
    
    private let facebookButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "btn_google_light_pressed_ios").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle(" Login with Facebook", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleFacebookLogin), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(
            string: "Don't have an account ",
            attributes: [
                .foregroundColor: UIColor(white: 1, alpha: 0.87),
                .font: UIFont.systemFont(ofSize: 16)
            ])
        attributedTitle.append(
            NSAttributedString(
                string: "Sign up",
                attributes: [
                    .foregroundColor: UIColor(white: 1, alpha: 0.87),
                    .font: UIFont.boldSystemFont(ofSize: 16)
                ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(
            self,
            action: #selector(showSignup),
            for: .touchUpInside)
        
        return button
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureUI()
        configureNotificationObservers()
        configureGoogleSignin()
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
                                    loginButton,
                                    forgotPasswordButton,
                                    dividerView])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 32,
                     paddingLeft: 32,
                     paddingRight: 32)
        
        let secondStack = UIStackView(arrangedSubviews: [
                                    forgotPasswordButton,
                                    dividerView,
                                    ])
        secondStack.axis = .vertical
        secondStack.spacing = 28
        
        view.addSubview(secondStack)
        secondStack.anchor(top: stack.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 24,
                     paddingLeft: 32,
                     paddingRight: 32)
        
        let thirdStack = UIStackView(arrangedSubviews:
                                        [
                                            googleButton,
                                            facebookButton
                                        ])
        thirdStack.axis = .vertical
        thirdStack.spacing = 14
        thirdStack.alignment = .leading
        
        view.addSubview(thirdStack)
        thirdStack.anchor(top: secondStack.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 24,
                     paddingLeft: 98,
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
    }
    
    func configureGoogleSignin() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
   
    // MARK: Selectors
    
    @objc func textDidChanged(_ sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        updateForm()
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        Service.logUserIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
               print("DEBUG: Error signing in.... \(error.localizedDescription)")
               return
            }

           print("Debug: Successfuly signed in.")
           debugPrint(result?.credential)
           self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func showForgotPassword() {
        let controller = ResetPasswordController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func showSignup() {
        let controller = RegisterController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleGoogleLogin() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc func handleFacebookLogin() {
        Service.signInWithFacebook(withController: self) { (error, reference) in
            if let error = error {
               print("DEBUG: Error signing in.... \(error.localizedDescription)")
               return
            }

           print("Debug: Successfuly signed in.")
           self.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: FormViewModel

extension LoginController: FormViewModel {
    func updateForm() {
        loginButton.isEnabled = viewModel.shouldEnableButton
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonColor, for: .normal)
    }
}

extension LoginController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn, didSignInFor user: GIDGoogleUser, withError error: Error!) {
        print("DEBUG: handle google signin \(user)")
        
        Service.signInWithGoogle(didSignInFor: user) { (error, ref) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("DEBUG: disconnect")
    }
}
