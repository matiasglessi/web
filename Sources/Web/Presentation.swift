//
//  Presentation.swift
//  
//
//  Created by Matias Glessi on 29/06/2022.
//

import Foundation
import Plot
import Publish

struct Presentation<Site: Website>: Component {
    var context: PublishingContext<Site>
    var page: Page

    init(context: PublishingContext<Site>, page: Page) {
        self.context = context
        self.page = page
    }
    
    var body: Component {
        Wrapper {
            H1("Hi 👋")
            ImageProfile.build(for: .pages).class("about-avatar")
            Paragraph(page.content.body)
        }.class("presentation")
    }
}
