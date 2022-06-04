//
//  MobileNavbar.swift
//  
//
//  Created by Matias Glessi on 04/06/2022.
//

import Foundation
import Plot
import Publish

struct MobileNavbar<Site: Website>: Component {
    var context: PublishingContext<Site>
    var mediaLinks: [MediaLink] { [.blog, .about] }
    
    var body: Component {
        Wrapper {
            H1("Matías Glessi | iOS Engineer 👨‍💻")
            Input(type: .checkbox).id("checkbox")
            Label("") {
                Image(
                    url: "images/menu.svg",
                    description: "Menu icon"
                ).class("menu-icon")
            }.attribute(named: "for", value: "checkbox")
            Wrapper {
                List(mediaLinks) { item in
                    Link(item.title, url: item.url)
                }.class("mediaLinks-list")
            }.class("dropdown-menu")
        }.class("mobile-navbar")
    }
}
