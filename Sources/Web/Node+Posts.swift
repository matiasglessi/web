//
//  Node+Posts.swift
//  
//
//  Created by Matias Glessi on 06/02/2022.
//

import Plot
import Publish
import Foundation

extension Node where Context == HTML.BodyContext {
    static func posts(for items: [Item<Web>], on site: Web, title: String) -> Node {
        return .pageContent(
            .div(
                .class("posts"),
                .h1(.class("content-subhead"), .text(title)),
                .forEach(items) { item in
                    .postExcerpt(for: item, on: site)
                }
            )
        )
    }
}

extension Node where Context == HTML.BodyContext {
    static func pageContent(_ nodes: Node...) -> Node {
        return .div(
            .class("content pure-u-1 pure-u-md-3-5 pure-u-xl-6-10"),
            .group(nodes)
        )
    }
}

extension Node where Context == HTML.BodyContext {
    static func postExcerpt(for item: Item<Web>, on site: Web) -> Node {
        return .section(
            .class("post"),
            .header(
                .class("post-header"),
                .h2(
                    .class("post-title"),
                    .a(
                        .href(item.path),
                        .text(item.title)
                    )
                ),
                .p(
                    .class("post-meta"),
                    .text(DateFormatter.blog.string(from: item.date)),
                    tagList(for: item, on: site)
                )
            ),
            .div(
                .class("post-description"),
                .p(.text(item.metadata.excerpt))
            )
        )
    }
}

extension Node where Context == HTML.BodyContext {
    static func tagList(for tags: [Tag], on site: Web) -> Node {
        return .div(.class("post-tags"), .forEach(tags) { tag in
            .a(
                .class("post-category post-category-\(tag.string.lowercased())"),
                .href(site.path(for: tag)),
                .text(tag.string)
            )
        })
    }
    
    static func tagList(for item: Item<Web>, on site: Web) -> Node {
        return .tagList(for: item.tags, on: site)
        
    }
    
    static func tagList(for page: TagListPage, on site: Web) -> Node {
        return .tagList(for: Array(page.tags), on: site)
    }
}

extension DateFormatter {
    static var blog: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}

extension Node where Context == HTML.BodyContext {
    static func footer(for site: Web) -> Node {
        let currentYear = Calendar.current.component(.year, from: Date())
        return .div(
            .class("footer pure-u-1"),
            .div(
                .class("pure-u-1"),
                .text("© \(currentYear)")
            ),
            .div(
                .class("pure-u-1"),
                .text("Generated using "),
                .a(
                    .text("Publish"),
                    .href("https://github.com/johnsundell/publish")
                ),
                .text(".")
            ),
            .div(
                .class("pure-u-1"),
                .text("Written in Swift.")
            )
        )
    }
}
