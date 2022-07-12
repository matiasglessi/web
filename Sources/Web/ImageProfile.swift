//
//  ImageProfile.swift
//  
//
//  Created by Matias Glessi on 01/07/2022.
//

import Foundation
import Publish
import Plot

enum ProfileType: String {
    case posts = "/../../images/avatar.jpg"
    case pages = "../images/avatar.jpg"
}

struct ImageProfile {
    static func build(for profileType: ProfileType) -> Image {
        Image(
            url: profileType.rawValue,
            description: "Matias Glessi's profile picture"
        )
    }
}






//http://localhost:8000/posts/Output/images/avatar.jpg
//http://localhost:8000/Output/images/avatar.jpg
