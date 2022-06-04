//
//  Navbar.swift
//  
//
//  Created by Matias Glessi on 04/06/2022.
//

import Foundation
import Plot
import Publish

extension MediaLink {
    static var blog: MediaLink {
        MediaLink(title: "BLOG", url: "http://google.com.ar", icon: "http://google.com.ar", classValue: "current")
    }
    static var about: MediaLink {
        MediaLink(title: "ABOUT", url: "http://google.com.ar", icon: "http://google.com.ar")
    }
}

struct Navbar<Site: Website>: Component {
    var context: PublishingContext<Site>
    var mediaLinks: [MediaLink] { [.blog, .about] }
    
    var body: Component {
        Wrapper {
            List(mediaLinks) { item in
                Link(item.title, url: item.url)
                    .class(item.classValue)
            }.class("mediaLinks-list")
        }.class("navbar")
    }
}
