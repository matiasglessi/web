//
//  Node+Head.swift
//
//
//  Created by Matias Glessi on 06/02/2022.
//

import Plot

extension Node where Context == HTML.DocumentContext {
    static func head(for site: Web) -> Node {
        return Node.head(
            .title("\(site.name) - \(site.description)"),
            .meta(
                .charset(.utf8),
                .name("viewport"),
                .content("width=device-width, initial-scale=1")
                /*
                 The viewport meta element lets you control the the width and scale of the viewport on mobile browsers. Since you're building a responsive website, you want the width to be equal to the device's native width
                 */
            ),
            .link(
                .rel(.stylesheet),
                .href("https://unpkg.com/purecss@1.0.1/build/pure-min.css"),
                .init(name: "integrity", value: "sha384-Uu6IeWbM+gzNVXJcM9XV3SohHtmWE+3VGi496jvgX1jyvDTXfdK+rfZc8C1Aehk5"),
                .init(name: "crossorigin", value: "anonymous")
            ),
            .link(
                .rel(.stylesheet),
                .href("https://unpkg.com/purecss@1.0.1/build/grids-responsive-min.css")
            ),
            .link(
                .rel(.stylesheet),
                .href("/Pure/styles.css")
            ),
            .link(
                .rel(.stylesheet),
                .href("/all.css")
            )
        )
    }
}
