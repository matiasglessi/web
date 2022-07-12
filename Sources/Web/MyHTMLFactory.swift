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
                    Sidebar(context: context, profileType: .pages)
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
                    Sidebar(context: context, profileType: .posts)
                    Wrapper {
                        Navbar(
                            context: context,
                            mediaLinks: mediaLinks
                        )
                        Wrapper {
                            Article {
                                PostHeader(context: context, item: item)
                                Div(item.content.body).class("content")
                                PostSignature(context: context, item: item)
                            }
                        }
                        SiteFooter()
                    }.class("right-content")
                }.class("container")
            }
        )
    }
        
    func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML {
        if page.isAbout() {
            let mediaLinks = [
                MediaLink(title: "BLOG", url: "http://localhost:8000/", icon: "http://google.com.ar"),
                MediaLink(title: "ABOUT", url: "http://localhost:8000/about/", icon: "http://google.com.ar", classValue: "current")
            ]
            
            let careerExperiences = [
                Experience(role: "Senior iOS Engineer", company: "Nike", companyLogo: "../images/logos/nike.jpeg", companyURL: "https://www.nike.com/", time: "Feb 2021 - Now", pagePath: "nike"),
                Experience(role: "iOS Engineer", company: "etermax", companyLogo: "../images/logos/etermax.jpeg", companyURL: "https://etermax.com/home/", time: "Nov 2018 - Feb 2021", pagePath: "etermax"),
                Experience(role: "iOS Developer", company: "IntermediaIT", companyLogo: "../images/logos/intermedia.jpeg", companyURL: "https://intermediait.com/", time: "Apr 2017 - Nov 2018", pagePath: "intermediait"),
                Experience(role: "iOS Developer", company: "Storyline", companyLogo: "../images/logos/storyline.png", companyURL: "", time: "Sept 2016 - Apr 2017", pagePath: "storyline"),
                Experience(role: "Java Developer", company: "Globant", companyLogo: "../images/logos/globant.jpeg", companyURL: "https://www.globant.com/", time: "Mar 2016 - Sept 2016", pagePath: "globant")
            ]
            
            let sideExperiences = [
                Experience(role: "Tech Content Creator", company: "Alkemy", companyLogo: "../images/logos/alkemy.jpeg", companyURL: "https://www.alkemy.org/", time: "July 2021 - Feb 2022", pagePath: "alkemy"),
                Experience(role: "iOS Consultant", company: "SocialWeaver", companyLogo: "../images/logos/socialWeaver.jpeg", companyURL: "https://www.socialweaver.com/", time: "July 2021 - Feb 2022", pagePath: "socialweaver")
            ]
            
            let education = [
                Experience(role: "Systems Engineer", company: "Universidad Nacional del Centro", companyLogo: "../images/logos/unicen.jpeg", companyURL: "https://www.unicen.edu.ar/", time: "", pagePath: "systemsengineer"),
                Experience(role: "UX and Inclusive Design", company: "Universidad Nacional del Centro", companyLogo: "../images/logos/unicen.jpeg", companyURL: "https://www.unicen.edu.ar/", time: "", pagePath: "uxdi")
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
                        Sidebar(context: context, profileType: .pages)
                        Wrapper {
                            Navbar(
                                context: context,
                                mediaLinks: mediaLinks
                            )
                            Wrapper {
                                Presentation(context: context, page: page)
                                H2("Career").class("resume-separator")
                                List(careerExperiences) { exp in
                                    ExperienceItem(experience: exp, context: context)
                                }.class("experiences-list")
                                H2("Extra - Consulting").class("resume-separator")
                                List(sideExperiences) { exp in
                                    ExperienceItem(experience: exp, context: context)
                                }.class("experiences-list")
                                H2("Education").class("resume-separator")
                                List(education) { edu in
                                    ExperienceItem(experience: edu, context: context)
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
    
    private func getPage(for institution: String, context: PublishingContext<Site>) -> Page {
        context.pages[Path(institution)]!
    }
    
    func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML? {
        nil
    }
    
    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? {
        nil
    }
}


extension Page {
    func isAbout() -> Bool {
        self.content.title == "About"
    }
}
