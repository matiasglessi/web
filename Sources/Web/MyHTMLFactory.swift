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
            MediaLink(title: "BLOG", url: "http://localhost:8000/", icon: "http://google.com.ar", classValue: "current"),
            MediaLink(title: "ABOUT", url: "http://localhost:8000/about/", icon: "http://google.com.ar")
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
//        if section.id.rawValue == "about" {
//            return HTML("about")
//        } else {
//            return HTML("otro")
//        }
        
        HTML("SectionHTML")
    }
    
    func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
        let mediaLinks = [
            MediaLink(title: "BLOG", url: "http://localhost:8000/", icon: "http://google.com.ar", classValue: "current"),
            MediaLink(title: "ABOUT", url: "http://localhost:8000/about/", icon: "http://google.com.ar")
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
                                PostHeader(context: context, item: item)
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
        if page.content.title == "About" {
            
            let mediaLinks = [
                MediaLink(title: "BLOG", url: "http://localhost:8000/", icon: "http://google.com.ar"),
                MediaLink(title: "ABOUT", url: "http://localhost:8000/about/", icon: "http://google.com.ar", classValue: "current")
            ]
            
            let experiences = [
                Experience(role: "Senior iOS Engineer", company: "Nike", companyLogo: "../images/logos/nike.jpeg", companyURL: "", time: "Feb 2021 - Now"),
                Experience(role: "iOS Consultant", company: "SocialWeaver", companyLogo: "../images/logos/socialWeaver.jpeg", companyURL: "", time: "July 2021 - Feb 2022"),
                Experience(role: "iOS Engineer", company: "etermax", companyLogo: "../images/logos/etermax.jpeg", companyURL: "", time: "Nov 2018 - Feb 2021"),
                Experience(role: "iOS Developer", company: "IntermediaIT", companyLogo: "../images/logos/intermedia.jpeg", companyURL: "", time: "Apr 2017 - Nov 2018"),
                Experience(role: "iOS Developer", company: "Storyline", companyLogo: "../images/logos/storyline.png", companyURL: "", time: "Sept 2016 - Apr 2017"),
                Experience(role: "Java Developer", company: "Globant", companyLogo: "../images/logos/globant.jpeg", companyURL: "", time: "Mar 2016 - Sept 2016")
            ]
            
            let education = [
                Experience(role: "Systems Engineer", company: "Universidad Nacional del Centro (Argentina) ", companyLogo: "../images/logos/unicen.jpeg", companyURL: "", time: ""),
                Experience(role: "UX and Inclusive Design", company: "Universidad Nacional del Centro (Argentina)", companyLogo: "../images/logos/unicen.jpeg", companyURL: "", time: "")
            ]

            
            return HTML(
                .lang(context.site.language),
                .head(for: page, on: context.site),
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
                                Presentation(context: context, page: page)
                                H2("Career").class("resume-separator")
                                List(experiences) { exp in
                                    ExperienceItem(site: context.site, experience: exp)
                                }.class("experiences-list")
                                H2("Education").class("resume-separator")
                                List(education) { edu in
                                    ExperienceItem(site: context.site, experience: edu)
                                }.class("education-list")
                            }.class("about-page-content")
                            SiteFooter()
                        }.class("right-content")
                    }.class("container")
                }
            )
            
        } else {
            return HTML("")
        }
        
    }
    
    func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML? {
        nil
    }
    
    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? {
        nil
    }
}


