//
//  ItemList.swift
//  
//
//  Created by Matias Glessi on 04/06/2022.
//

import Foundation
import Plot
import Publish

struct ItemList<Site: Website>: Component {
    var items: [Item<Site>]
    var site: Site

    var body: Component {
        List(items) { item in
            Article {
                H4(item.date.asBlogString())
                H1(Link(item.title, url: item.path.absoluteString))
                Paragraph(item.description)
            }
        }
        .class("item-list")
    }
}
