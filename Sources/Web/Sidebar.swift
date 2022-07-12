//
//  Sidebar.swift
//  
//
//  Created by Matias Glessi on 04/06/2022.
//

import Foundation
import Publish
import Plot

struct Sidebar<Site: Website>: Component {
    var context: PublishingContext<Site>
    var mediaLinks: [MediaLink] { [.location, .email, .linkedIn, .github] }
    var profileType: ProfileType
    
    var body: Component {
        Wrapper {
            ImageProfile.build(for: profileType)
            H1("Matías Glessi")
            H2("iOS Engineer")
            Wrapper {
                List(mediaLinks) { item in
                    Wrapper {
                        Link(item.title, url: item.url)
                    }.class(item.classValue)
                }.class("mediaLinks-list")
            }
        }.class("sidebar")
    }
}

extension MediaLink {
    static var location: MediaLink {
        MediaLink(title: "La Plata, Argentina  🇦🇷", url: "https://es.wikipedia.org/wiki/La_Plata", icon: "images/point.png", classValue: "location")
    }
    static var email: MediaLink {
        MediaLink(title: "matiasglessi@gmail.com", url: "mailto:matiasglessi@gmail.com", icon: "images/mail.png", classValue: "mail")
    }
    static var linkedIn: MediaLink {
        MediaLink(title: "LinkedIn", url: "https://www.linkedin.com/in/matias-alejandro-glessi/", icon: "images/linkedin.svg", classValue: "linkedin")
    }
    static var github: MediaLink {
        MediaLink(title: "GitHub", url: "https://github.com/matiasglessi", icon: "images/github.svg", classValue: "github")
    }
}
