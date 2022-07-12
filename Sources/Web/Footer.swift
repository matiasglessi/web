//
//  Footer.swift
//  
//
//  Created by Matias Glessi on 04/06/2022.
//

import Foundation
import Plot

struct SiteFooter: Component {
    var body: Component {
        Footer {
            Wrapper {
                Div()
            }.class("section-breaker")
            Paragraph {
                Text("Generated in Swift ❤️, using ")
                Link("Publish", url: "https://github.com/johnsundell/publish")
            }
            Paragraph {
                Text("© Copyright 2022")
            }
        }
    }
}
