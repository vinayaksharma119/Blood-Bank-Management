//
//  EmptyTableViewState.swift
//  Blood Bank
//
//  Created by Vinayak Sharma on 19/05/20.
//  Copyright © 2020 Vinayak Sharma. All rights reserved.
//

import UIKit

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        if traitCollection.userInterfaceStyle == .light{
            messageLabel.textColor = .black
        } else{
            messageLabel.textColor = .white
        }
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
