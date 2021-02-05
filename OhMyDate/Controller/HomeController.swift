//
//  HomeController.swift
//  OhMyDate
//
//  Created by Carlo Carpio on 2/4/21.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    //MARK: Properties
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        authenticateUser()
    }
    
    //MARK: API
    
    fileprivate func presentLoginController() {
        let controller = LoginController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func authenticateUser() {
        if Auth.auth().currentUser == nil {
            print("DEBUG: User not logged in.")
            DispatchQueue.main.async {
                self.presentLoginController()
            }
        } else {
            print("DEBUG: User is logged in.")
            debugPrint(Auth.auth().currentUser?.getIDToken(completion: { (idToken, error) in
                if let error = error {
                    print("DEBUG: Error \(error.localizedDescription)")
                }
                
                debugPrint(idToken)
            }))
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            self.presentLoginController()
        } catch {
            print("DEBUG: Error logging out.")
        }
    }
    
    //MARK: Helpers
    
    func configureUI() {
        configureGradientBackground()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Ohmydate"
        
        let image = UIImage(systemName: "arrow.left")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    //MARK: Selectors
    
    @objc func handleLogout() {
        let alert = UIAlertController(
            title: nil,
            message: "Are you sure you want to log out?",
            preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { _ in
            self.logout()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
