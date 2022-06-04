//
//  Date+PostDate.swift
//  
//
//  Created by Matias Glessi on 04/06/2022.
//

import Foundation

extension Date {
    
    func asBlogString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: self).uppercased()
    }
}
