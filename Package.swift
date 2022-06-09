// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Web",
    products: [
        .executable(
            name: "Web",
            targets: ["Web"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.7.0"),
        .package(name: "SplashPublishPlugin", url: "https://github.com/johnsundell/splashpublishplugin", from: "0.1.0"),
        .package(name: "ReadingTimePublishPlugin", url: "https://github.com/alexito4/ReadingTimePublishPlugin", from: "0.2.0")
    ],
    targets: [
        .target(
            name: "Web",
            dependencies: [
                "Publish",
                "SplashPublishPlugin",
                "ReadingTimePublishPlugin"
            ]
        )
    ]
)
