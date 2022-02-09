import Foundation
import Publish
import Plot
import SplashPublishPlugin


// This type acts as the configuration for your website.
struct Web: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
        case about
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
        var excerpt: String
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://matiasglessi.com")!
    var name = "Matias Glessi"
    var description = "iOS Engineer"
    var language: Language { .english }
    var imagePath: Path? { nil }
    var socialMediaLinks: [SocialMediaLink] { [.location, .email, .linkedIn, .github, .twitter] }

}

// This will generate your website using the built-in Foundation theme:
try Web().publish(withTheme: .web,
                  plugins: [.splash(withClassPrefix: "")])

extension Theme where Site == Web {
    static var web: Self {
        Theme(htmlFactory: WebHTMLFactory())
    }
}

struct WebHTMLFactory: HTMLFactory {
    typealias Site = Web

    func makeSectionHTML(for section: Section<Web>, context: PublishingContext<Web>) throws -> HTML {
        HTML("")
    }
    
    func makeItemHTML(for item: Item<Web>, context: PublishingContext<Web>) throws -> HTML {
        HTML("")
    }
    
    func makePageHTML(for page: Page, context: PublishingContext<Web>) throws -> HTML {
        HTML("")
    }
    
    func makeTagListHTML(for page: TagListPage, context: PublishingContext<Web>) throws -> HTML? {
        nil
    }
    
    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Web>) throws -> HTML? {
        nil
    }
    
    
    func makeIndexHTML(for index: Index, context: PublishingContext<Web>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: context.site),
            .body(
                .grid(
                    .header(for: context.site),
                    .sidebar(for: context.site),
                    .posts(
                        for: context.allItems(
                            sortedBy: \.date,
                            order: .descending
                        ),
                        on: context.site,
                        title: "Recent posts"
                    ),
                    .footer(for: context.site)
                )
            )
        )
    }
}
