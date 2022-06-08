//
//  PostHeader.swift
//  
//
//  Created by Matias Glessi on 08/06/2022.
//

import Foundation

import Foundation
import Plot
import Publish

struct PostHeader<Site: Website>: Component {
    var context: PublishingContext<Site>
    var mediaLinks: [MediaLink]

    init(context: PublishingContext<Site>, mediaLinks: [MediaLink] = []) {
        self.context = context
        self.mediaLinks = mediaLinks
    }
    
    var body: Component {
        Wrapper {
            H1("Matías Glessi 👨‍💻")
            List(mediaLinks) { item in
                Link(item.title.capitalized, url: item.url)
                    .class(item.classValue)
            }.class("mediaLinks-list")
        }.class("mobile-navbar")
    }

}

