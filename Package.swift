// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Forethought",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "Forethought", 
            targets: ["Forethought"]
        )
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "Forethought", 
            path: "Forethought.xcframework"
        )
    ]
)
