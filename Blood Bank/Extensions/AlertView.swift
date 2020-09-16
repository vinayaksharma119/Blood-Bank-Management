//
//  AlertView.swift
//  Blood Bank
//
//  Created by Vinayak Sharma on 17/04/20.
//  Copyright © 2020 Vinayak Sharma. All rights reserved.
//

import UIKit

extension UIViewController {

  func presentAlert(withTitle title: String, message : String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let actionButton = UIAlertAction(title: "Ok", style: .default) { action in
        self.dismiss(animated: true)
    }
    alertController.addAction(actionButton)
    self.present(alertController, animated: true, completion: nil)
  }
}
