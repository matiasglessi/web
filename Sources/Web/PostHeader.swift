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
        if let link = isCrossPosted(item) {
           return Link("Cross posted on Medium", url: link).class("linked-label")
        }
        return Label("N/A — no external link"){}.class("no-link-label")
    }
    
    var body: Component {
        Wrapper {
            H4(item.date.asBlogString())
            H1(Link(item.title, url: item.path.absoluteString))
            List([readingTime, crossPostLink]) { $0 }.class("post-header-links")
            Wrapper {
                Div()
            }.class("header-section-breaker")
        }.class("post-header")
    }

    func isCrossPosted(_ item: Item<Site>) -> String? {
        if let metadata = item.metadata as? Web.ItemMetadata,
           let crossPostedLink = metadata.crossPosted {
            return crossPostedLink
        }
        return nil
    }
}
