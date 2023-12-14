// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Stefan",
    products: [
        .library(
            name: "Stefan",
            targets: ["Stefan"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/appunite/Differ", exact: "1.4.6")
    ],
    targets: [
        .target(
            name: "Stefan",
            dependencies: ["Differ"]
        ),
        .testTarget(
            name: "StefanTests",
            dependencies: ["Stefan"]
        ),
    ]
)
