//
//  LoginViewController.swift
//  Blood Bank
//
//  Created by Vinayak Sharma on 17/04/20.
//  Copyright © 2020 Vinayak Sharma. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBOutlet var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 20
        signInButton.tintColor = .white
        signInButton.backgroundColor = .systemGreen
        hideKeyboardWhenTappedAround()
        
    }
    
    
    @IBAction func signInTapped(_ sender: Any) {
        guard let emailText = email.text, !emailText.isEmpty else {
            self.presentAlert(withTitle: "", message: "Enter email")
            return}
        guard let passwordText = password.text, !passwordText.isEmpty else {
            self.presentAlert(withTitle: "", message: "Enter password")
            return}
        navigationItem.hidesBackButton = true
        self.showAnimation()
        
        Auth.auth().signIn(withEmail: emailText, password: passwordText, completion: { [weak self] (user, error) in
                guard let self = self else {return}
                if error != nil {
                    if let errCode = AuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                        case .invalidEmail:
                            self.presentAlert(withTitle: "Inavlid email", message: "Please enter a valid email")
                        case .wrongPassword:
                            self.presentAlert(withTitle: "Something went wrong", message: "Password  you entered is incorrect")
                        case .userNotFound:
                            self.presentAlert(withTitle: "User not found", message: "User not exists")
                        case .networkError:
                            self.presentAlert(withTitle: "Network error", message: "Please check your internet and try again")
                        default:
                            self.presentAlert(withTitle: "Something went wrong", message: "Internal error")
                         
                        }
                                
                    }
                    self.removeAnimation()
                    self.navigationItem.hidesBackButton = false
                }
                else {
                    print("login successful")
                    self.removeAnimation()
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                }
            })
    }
            
        
    
    }
    
   
