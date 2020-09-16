//
//  WelcomeViewController.swift
//  Blood Bank
//
//  Created by Vinayak Sharma on 17/04/20.
//  Copyright © 2020 Vinayak Sharma. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    
    @IBOutlet var register: UIButton!
    @IBOutlet var signIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        register.layer.cornerRadius = 20
        signIn.layer.cornerRadius = 20
        register.tintColor = .white
        register.backgroundColor = .systemRed
        signIn.tintColor = .white
        signIn.backgroundColor = .systemGreen
    }
}
