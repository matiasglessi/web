//
//  Node+Header.swift
//  
//
//  Created by Matias Glessi on 06/02/2022.
//

import Plot

extension Node where Context == HTML.BodyContext {
    private static var sections: [Web.SectionID] { [Web.SectionID.about] }
    
    static func header(for site: Web) -> Node {
        return .div(
            .div(
                .class("pure-menu pure-menu-horizontal pure-u-1-1 top-header"),
                .a(
                    .class("pure-menu-heading"),
                    .text("Posts"),
                    .href("/")
                ),
                .ul(
                    .class("pure-menu-list"),
                    .forEach(sections, { section in
                        .li(
                            .class("pure-menu-item"),
                            .a(
                                .class("pure-menu-link"),
                                .text(section.rawValue.capitalized),
                                .href(site.path(for: section))
                            )
                        )
                    })
                )
            )
        )
    }
}
