//
//  ExperienceItem.swift
//  
//
//  Created by Matias Glessi on 29/06/2022.
//

import Foundation
import Plot
import Publish
import Ink

struct ExperienceItem<Site: Website>: Component {
    var experience: Experience
    var context: PublishingContext<Site>

    var page: Page? {
        context.pages[Path(experience.pagePath)]
    }
    
    var body: Component {
        Article {
            Image(url: experience.companyLogo, description: "Company Logo")
            H3(experience.role)
            H4(Link(experience.company, url: experience.companyURL))
            if let page = page {
                Div(page.content.body).class("experience-description")
            }
        }
        .class("experience-item")
    }
}

struct Experience {
    let role: String
    let company: String
    let companyLogo: URLRepresentable
    let companyURL: URLRepresentable
    let time: String
    let pagePath: String
}
