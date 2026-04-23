// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "DateExtension",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "DateExtension",
            targets: ["DateExtension"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DateExtension"
        ),
        .testTarget(
            name: "DateExtensionTests",
            dependencies: ["DateExtension"]
        )
    ]
)
