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
    var name = "Matias Glessi | iOS Engineer"
    var description = ""
    var language: Language { .english }
    var imagePath: Path? { nil }
    var mediaLinks: [MediaLink] { [.location, .email, .linkedIn, .github] }
}

public struct MediaLink {
    let title: String
    let url: URLRepresentable
    let icon: URLRepresentable
    let classValue: String
    
    init(title: String, url: URLRepresentable, icon: URLRepresentable, classValue: String = "mediaLink") {
        self.title = title
        self.url = url
        self.icon = icon
        self.classValue = classValue
    }
}

extension MediaLink {
    static var location: MediaLink {
        MediaLink(title: "La Plata, Argentina 🇦🇷", url: "https://es.wikipedia.org/wiki/La_Plata", icon: "images/point.png", classValue: "location")
    }
    static var email: MediaLink {
        MediaLink(title: "matiasglessi@gmail.com", url: "mailto:matiasglessi@gmail.com", icon: "images/mail.png", classValue: "mail")
    }
    static var linkedIn: MediaLink {
        MediaLink(title: "LinkedIn", url: "https://www.linkedin.com/in/matias-alejandro-glessi/", icon: "images/linkedin.svg", classValue: "linkedin")
    }
    static var github: MediaLink {
        MediaLink(title: "GitHub", url: "https://github.com/matiasglessi", icon: "images/github.svg", classValue: "github")
    }
}

private struct Wrapper: ComponentContainer {
    @ComponentBuilder var content: ContentProvider

    var body: Component {
        Div(content: content).class("wrapper")
    }
}

private struct SiteFooter: Component {
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

extension MediaLink {
    static var blog: MediaLink {
        MediaLink(title: "BLOG", url: "http://google.com.ar", icon: "http://google.com.ar", classValue: "current")
    }
    static var about: MediaLink {
        MediaLink(title: "ABOUT", url: "http://google.com.ar", icon: "http://google.com.ar")
    }
}

private struct Navbar<Site: Website>: Component {
    var context: PublishingContext<Site>
    var mediaLinks: [MediaLink] { [.blog, .about] }
    
    var body: Component {
        Wrapper {
            List(mediaLinks) { item in
                Link(item.title, url: item.url)
                    .class(item.classValue)
            }.class("mediaLinks-list")
        }.class("navbar")
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
            H1("Matías Glessi")
            H2("iOS Engineer")
            Wrapper {
                List(mediaLinks) { item in
                    Wrapper {
                        Link(item.title, url: item.url)
                    }.class(item.classValue)
                }.class("mediaLinks-list")
            }
        }.class("sidebar")
    }
}

private struct ItemTagList<Site: Website>: Component {
    var item: Item<Site>
    var site: Site

    var body: Component {
        List(item.tags) { tag in
            Link(tag.string, url: site.path(for: tag).absoluteString)
        }
        .class("tag-list")
    }
}

private struct ItemList<Site: Website>: Component {
    var items: [Item<Site>]
    var site: Site

    var body: Component {
        List(items) { item in
            Article {
                H4(item.date.asBlogString())
                H1(Link(item.title, url: item.path.absoluteString))
                Paragraph(item.description)
            }
        }
        .class("item-list")
    }
}

extension Date {
    
    func asBlogString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: self).uppercased()
    }
}


private struct MobileNavbar<Site: Website>: Component {
    var context: PublishingContext<Site>
    var mediaLinks: [MediaLink] { [.blog, .about] }
    
    var body: Component {
        Wrapper {
            H1("Matías Glessi | iOS Engineer 👨‍💻")
            Image(
                url: "images/menu.svg",
                description: "Menu icon"
            )
            Input(type: .checkbox).id("checkbox")
            Label("") {
                Image(
                    url: "images/menu.svg",
                    description: "Menu icon"
                ).class("menu-icon")
            }.attribute(named: "for", value: "checkbox")
            Wrapper {
                List(mediaLinks) { item in
                    Link(item.title, url: item.url)
                }.class("mediaLinks-list")
            }.class("dropdown-menu")
        }.class("mobile-navbar")
    }
}

struct MyHTMLFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body {
                Wrapper {
                    MobileNavbar(context: context)
                    Sidebar(context: context)
                    Wrapper {
                        Navbar(context: context)
                        ItemList(
                            items: context.allItems(
                                sortedBy: \.date,
                                order: .descending
                            ),
                            site: context.site
                        )
                        SiteFooter()
                    }.class("right-content")
                }.class("container")
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


