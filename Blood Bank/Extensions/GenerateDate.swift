//
//  GenerateDate.swift
//  Blood Bank
//
//  Created by Vinayak Sharma on 05/09/20.
//  Copyright © 2020 Vinayak Sharma. All rights reserved.
//

import Foundation
extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
