// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AppleTVHubAnalyzer",
    platforms: [
        .tvOS(.v17) // Designed for modern tvOS architectures
    ],
    products: [
        .library(
            name: "AppleTVHubAnalyzer",
            targets: ["AppleTVHubAnalyzer"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AppleTVHubAnalyzer",
            path: "Sources",
            linkerSettings: [
                .linkedFramework("UIKit"),
                .linkedFramework("Network"),
                .linkedFramework("CoreServices")
            ]
        )
    ]
)
