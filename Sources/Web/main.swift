import Foundation
import Publish
import Plot
import SplashPublishPlugin
import ReadingTimePublishPlugin

// This type acts as the configuration for your website.
struct Web: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
        case about
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
        var crossPosted: String?
        var pullRequest: String?
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://matiasglessi.com")!
    var name = "Matias Glessi | iOS Engineer"
    var description = ""
    var language: Language { .english }
    var imagePath: Path? { nil }
}

try Web().publish(using: [
    .installPlugin(.splash(withClassPrefix: "")),
    .copyResources(),
    .addMarkdownFiles(),
    .sortItems(by: \.date, order: .descending),
    .installPlugin(.readingTime()),
    .generateHTML(withTheme: .myTheme)
])
