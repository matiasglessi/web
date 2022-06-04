//
//  Theme+MyTheme.swift
//  
//
//  Created by Matias Glessi on 04/06/2022.
//

import Publish

extension Theme {
    static var myTheme: Theme {
        Theme(
            htmlFactory: MyHTMLFactory(),
            resourcePaths: ["Resources/MyTheme/styles.css"]
        )
    }
}
