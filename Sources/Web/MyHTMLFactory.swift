//
//  MyHTMLFactory.swift
//  
//
//  Created by Matias Glessi on 04/06/2022.
//

import Foundation
import Publish
import Plot

struct MyHTMLFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
        
        let mediaLinks = [
            MediaLink(title: "BLOG", url: "http://google.com.ar", icon: "http://google.com.ar", classValue: "current"),
            MediaLink(title: "ABOUT", url: "http://google.com.ar", icon: "http://google.com.ar")
        ]
        
        return HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body {
                Wrapper {
                    MobileNavbar(
                        context: context,
                        mediaLinks: mediaLinks
                    )
                    Sidebar(context: context)
                    Wrapper {
                        Navbar(
                            context: context,
                            mediaLinks: mediaLinks
                        )
                        ItemList(
                            items: context.allItems(
                                sortedBy: \.date,
                                order: .descending
                            ),
                            site: context.site
                        )
                        SiteFooter()
                    }.class("right-content")
                }.class("container")
            }
        )
    }
    
    func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML("")
    }
    
    func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
        let mediaLinks = [
            MediaLink(title: "BLOG", url: "http://google.com.ar", icon: "http://google.com.ar", classValue: "current"),
            MediaLink(title: "ABOUT", url: "http://google.com.ar", icon: "http://google.com.ar")
        ]

        return HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .body {
                Wrapper {
                    MobileNavbar(
                        context: context,
                        mediaLinks: mediaLinks
                    )
                    Sidebar(context: context)
                    Wrapper {
                        Navbar(
                            context: context,
                            mediaLinks: mediaLinks
                        )
                        Wrapper {
                            Article {
                                PostHeader(context: context)
                                Div(item.content.body).class("content")
                            }
                        }
                        SiteFooter()
                    }.class("right-content")
                }.class("container")
            }
        )
    }
    
    func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML {
        HTML("")
    }
    
    func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML? {
        nil
    }
    
    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? {
        nil
    }
}
