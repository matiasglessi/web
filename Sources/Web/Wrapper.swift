//
//  Wrapper.swift
//  
//
//  Created by Matias Glessi on 04/06/2022.
//

import Foundation
import Publish
import Plot

struct Wrapper: ComponentContainer {
    @ComponentBuilder var content: ContentProvider

    var body: Component {
        Div(content: content).class("wrapper")
    }
}
