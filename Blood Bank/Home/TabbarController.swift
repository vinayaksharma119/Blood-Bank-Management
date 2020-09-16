//
//  TabbarController.swift
//  Blood Bank
//
//  Created by Vinayak Sharma on 17/04/20.
//  Copyright © 2020 Vinayak Sharma. All rights reserved.
//

import UIKit
import Firebase
class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            if Auth.auth().currentUser == nil {
                let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "firstNav") as! UINavigationController
                self.present(vc,animated: false,completion: nil)
            }
            
        }
        navigationController?.isNavigationBarHidden = true
    }
    

    

}
