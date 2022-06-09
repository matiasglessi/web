//
//  PostHeader.swift
//  
//
//  Created by Matias Glessi on 08/06/2022.
//

import Foundation
import Plot
import Publish

struct PostHeader<Site: Website>: Component {
    var item: Item<Site>
    var context: PublishingContext<Site>
    
    var readingTime: Component  {
        Label("Reading Time: \(item.readingTime.minutes) minutes"){}.class("reading-time") }
        
    init(context: PublishingContext<Site>, item: Item<Site>) {
        self.context = context
        self.item = item
    }

    var crossPostLink: Component {
        if isCrossPosted(item) {
           return Link("Cross posted on Medium", url: "https://google.com.ar").class("linked-label")
        }
        return Label("N/A — no external link"){}.class("no-link-label")
    }
    
    var body: Component {
        Wrapper {
            H4(item.date.asBlogString())
            H1(Link(item.title, url: item.path.absoluteString))
            List([readingTime, crossPostLink]) { $0 }.class("post-header-links")
        }.class("post-header")
    }

    func isCrossPosted(_ item: Item<Site>) -> Bool {
//        if let item1 = item as? WebsiteItemMetadata {
//            item1.
//        }
        return false
    }
}
