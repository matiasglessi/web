//
//  PostSignature.swift
//  
//
//  Created by Matias Glessi on 07/07/2022.
//

import Foundation
import Plot
import Publish

struct PostSignature<Site: Website>: Component {
    var item: Item<Site>
    var context: PublishingContext<Site>
    
    init(context: PublishingContext<Site>, item: Item<Site>) {
        self.context = context
        self.item = item
    }
    
    var mailLink: Component {
        Link("here", url: "mailto:matiasglessi@gmail.com")
    }
    
    var pullRequestLink: Component {
        Link("on Github", url: hasPullRequestLink(item))
    }
    
    var body: Component {
        Wrapper {
            Paragraph {
                Text("---")
            }
            Paragraph {
                Text("Hey! Thanks for getting this far! 😊")
            }
            Paragraph {
                Text("Do you see something strange or wrong in this article? It's hosted ")
                pullRequestLink
                Text(", you can open a Pull Request for discussion and request an edit. You can also contact me directly ")
                mailLink
                Text(".")
            }
        }.class("post-signature")
    }

    func hasPullRequestLink(_ item: Item<Site>) -> String {
        if let metadata = item.metadata as? Web.ItemMetadata,
           let pullRequestLink = metadata.pullRequest {
            return pullRequestLink
        }
        return ""
    }
}
