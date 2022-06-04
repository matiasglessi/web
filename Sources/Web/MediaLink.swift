//
//  MediaLink.swift
//  
//
//  Created by Matias Glessi on 04/06/2022.
//

import Foundation
import Plot

public struct MediaLink {
    let title: String
    let url: URLRepresentable
    let icon: URLRepresentable
    let classValue: String
    
    init(title: String, url: URLRepresentable, icon: URLRepresentable, classValue: String = "mediaLink") {
        self.title = title
        self.url = url
        self.icon = icon
        self.classValue = classValue
    }
}
