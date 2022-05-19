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
    var mediaLinks: [MediaLink] { [.location, .email, .linkedIn, .github] }
}

public struct MediaLink {
    let title: String
    let url: URLRepresentable
    let icon: URLRepresentable
}

extension MediaLink {
    static var location: MediaLink {
        MediaLink(title: "La Plata, Argentina 🇦🇷", url: "http://google.com.ar", icon: "http://google.com.ar")
    }
    static var email: MediaLink {
        MediaLink(title: "matiasglessi@gmail.com", url: "http://google.com.ar", icon: "http://google.com.ar")
    }
    static var linkedIn: MediaLink {
        MediaLink(title: "LinkedIn", url: "http://google.com.ar", icon: "http://google.com.ar")
    }
    static var github: MediaLink {
        MediaLink(title: "Github", url: "http://google.com.ar", icon: "http://google.com.ar")
    }
}

private struct Wrapper: ComponentContainer {
    @ComponentBuilder var content: ContentProvider

    var body: Component {
        Div(content: content).class("wrapper")
    }
}

private struct Sidebar<Site: Website>: Component {
    var context: PublishingContext<Site>
    var mediaLinks: [MediaLink] { [.location, .email, .linkedIn, .github] }

    var body: Component {
        Wrapper {
            Image(
                url: "https://avatars0.githubusercontent.com/u/9439622?s=460&v=4",
                description: "Matias Glessi's profile picture"
            )
            H1("Matias Glessi")
            H2("iOS Engineer")
            Wrapper {
                List(mediaLinks) { item in
                    H3(item.title)
                }.class("mediaLinks-list")
            }
        }
    }
}

struct MyHTMLFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body {
                Sidebar(context: context)
            }
        )	
    }
    
    func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML("")
    }
    
    func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML("")
    }
    
    func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML {
        HTML("")
    }
    
    func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML? {
        nil
    }
    
    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? {
        nil
    }
}

extension Theme {
    static var myTheme: Theme {
        Theme(
            htmlFactory: MyHTMLFactory(),
            resourcePaths: ["Resources/MyTheme/styles.css"]
        )
    }
}
// This will generate your website using the built-in Foundation theme:
try Web().publish(withTheme: .myTheme)


