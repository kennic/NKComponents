// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NKComponents",
    products: [
        .library(
            name: "NKComponents",
            targets: ["NKComponents"]),
    ],
    dependencies: [
         .package(url: "https://github.com/kennic/NKButton.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "NKComponents",
            dependencies: [])
    ]
)
