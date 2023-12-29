// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "TLPageView",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "TLPageView", targets: ["TLPageView"])
    ],
    targets: [
        .target(
            name: "TLPageView",
            dependencies: []
        )
    ]
)
