// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Stefan",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "Stefan",
            targets: ["Stefan"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/tonyarnold/Differ",
            from: "1.4.6"
        )
    ],
    targets: [
        .target(
            name: "Stefan",
            dependencies: [
                .product(
                    name: "Differ",
                    package: "Differ"
                )
            ]
        ),
        .testTarget(
            name: "StefanTests",
            dependencies: ["Stefan"]
        ),
    ]
)
