//
//  MediaLink.swift
//  
//
//  Created by Matias Glessi on 04/06/2022.
//

import Foundation
import Plot

public class MediaLink {
    let title: String
    let url: URLRepresentable
    let icon: URLRepresentable
    var classValue: String
    
    init(title: String, url: URLRepresentable, icon: URLRepresentable, classValue: String = "mediaLink") {
        self.title = title
        self.url = url
        self.icon = icon
        self.classValue = classValue
    }
    
    func setAsCurrent() {
        self.classValue = "current"
    }
}

extension MediaLink {
    
    enum BuilderType {
        case about
        case blog
    }
    
    static func build(for type: BuilderType) -> MediaLink {
        switch type {
        case .blog:
            return MediaLink(title: "BLOG", url: "/index.html", icon: "")
        case .about :
            return MediaLink(title: "ABOUT", url: "/about/index.html", icon: "")
        }
    }
    
    func current() -> MediaLink {
        let temporal = self
        temporal.classValue = "current"
        return temporal
    }
}
