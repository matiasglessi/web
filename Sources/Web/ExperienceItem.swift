//
//  ExperienceItem.swift
//  
//
//  Created by Matias Glessi on 29/06/2022.
//

import Foundation
import Plot
import Publish




struct ExperienceItem<Site: Website>: Component {
    var site: Site
    var experience: Experience
    
    var body: Component {
        Article {
            Image(url: experience.companyLogo, description: "Company Logo")
            H3(experience.role)
            H4(Link(experience.company, url: experience.companyURL))
            //H5(experience.time)
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
}
