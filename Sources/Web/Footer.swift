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
            Paragraph {
                Text("Generated using ")
                Link("Publish", url: "https://github.com/johnsundell/publish")
            }
            Paragraph {
                Text("2022")
            }
        }
    }
}
