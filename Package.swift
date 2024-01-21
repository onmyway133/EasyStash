// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EasyStash",
    platforms: [
        .iOS(.v15),
        .tvOS(.v13),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "EasyStash",
            targets: ["EasyStash"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "EasyStash",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "EasyStashTests",
            dependencies: ["EasyStash"]
        )
    ]
)
