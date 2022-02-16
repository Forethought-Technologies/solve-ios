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
            targets: ["Forethought"]),
				.library(
						name: "KustomerPlugin",
						targets: ["KustumorPlugin"])
    ],
    targets: [
        .binaryTarget(
            name: "Forethought", 
            path: "Forethought.xcframework")
				.target(
						name: "KustomerPlugin",
						dependencies:[
							.target(name: "Forethought"),
							.package(url: "https://github.com/kustomer/kustomer-ios", from: "2.4.11")
						]),
						path: "Plugins/Kustomer")
    ]
)
