//
//  Service.swift
//  OhMyDate
//
//  Created by Carlo Carpio on 2/4/21.
//

import Foundation
import Firebase
import GoogleSignIn
import FBSDKLoginKit

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct Service {
    
    static func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUserWithFirebase(withEmail email: String, password: String, fullname: String, completion: @escaping(DatabaseCompletion)) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Error \(error.localizedDescription)")
                return
            }
            
            guard let uid = result?.user.uid else  { return }
            let values = ["email": email, "fullname": fullname]
            Database.database().reference().child(uid).updateChildValues(values, withCompletionBlock: completion)
            
        }
    }
    
    static func signInWithGoogle(didSignInFor user: GIDGoogleUser, completion: @escaping(DatabaseCompletion)) {
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                print("DEBUG: Failed to signin with Google. \(error.localizedDescription)")
                return
            }
            
            guard let uid = result?.user.uid else  { return }
            guard let email = result?.user.email else  { return }
            guard let fullname = result?.user.displayName else  { return }
            let values = ["email": email, "fullname": fullname]
            Database.database().reference().child(uid).updateChildValues(values, withCompletionBlock: completion)
        }
    }
    
    static func signInWithFacebook(withController controller: UIViewController, completion: @escaping DatabaseCompletion) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"] , viewController: controller) { loginResult in
        
            switch loginResult {
                case .failed(let error):
                    print(error)
                    print("DEBUG: User failed login.")
                case .cancelled:
                    print("DEBUG: User cancelled login.")
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
//                    self.getFBUserData()
                    print("DEBUG: User login success.")
                    
                    if((AccessToken.current) != nil){
                        GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                            if (error == nil){
                                let dict = result as? [String : AnyObject]
                                print(dict)

                                guard let Username = dict?["name"]! as? String else { return }
                                guard let UserId = dict?["id"]! as? String else { return }
                                guard let Useremail = dict?["email"]! as? String else { return }
                                let params = ["provider_user_id": UserId , "name": Username, "email": Useremail ,"provider": "FacebookProvider"] as! [String: AnyObject]
                                //Do your sign in network call here with parameter
                                
                                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                                
                                Auth.auth().signIn(with: credential) { (result, error) in
                                    if let error = error {
                                        print("DEBUG: Failed to signin with Google. \(error.localizedDescription)")
                                        return
                                    }
                                    
                                    guard let uid = result?.user.uid else  { return }
                                    guard let email = result?.user.email else  { return }
                                    guard let fullname = result?.user.displayName else  { return }
                                    let values = ["email": email, "fullname": fullname]
                                    
                                    print("DEBUG: \(uid)")
                                    print("DEBUG: \(email)")
                                    print("DEBUG: \(fullname)")
                                    
//                                    Database.database().reference().child(uid).updateChildValues(values, withCompletionBlock: completion)
                                    Database.database().reference().child(uid).updateChildValues(values, withCompletionBlock: completion)
                                }
                            }
                        })
                    }
                }
            }
    }
    
}
