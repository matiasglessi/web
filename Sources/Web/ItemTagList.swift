//
//  ItemTagList.swift
//  
//
//  Created by Matias Glessi on 04/06/2022.
//

import Foundation
import Plot
import Publish

struct ItemTagList<Site: Website>: Component {
    var item: Item<Site>
    var site: Site

    var body: Component {
        List(item.tags) { tag in
            Link(tag.string, url: site.path(for: tag).absoluteString)
        }
        .class("tag-list")
    }
}
