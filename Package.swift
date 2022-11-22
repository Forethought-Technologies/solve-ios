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
						targets: ["KustomerPlugin"]),
				.library(
						name: "ZendeskPlugin",
						targets: ["ZendeskPlugin"]),
				.library(
						name: "IntercomPlugin",
						targets: ["IntercomPlugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kustomer/kustomer-ios", from: "2.7.4"),
        .package(url: "https://github.com/zendesk/chat_sdk_ios", from: "3.0.0"),
        .package(url: "https://github.com/intercom/intercom-ios", from: "14.0.1"),
    ],
    targets: [
        .binaryTarget(
            name: "Forethought", 
            path: "Forethought.xcframework"),
        .target(
                name: "KustomerPlugin",
                dependencies:[
                    .target(name: "Forethought"),
                    .product(name: "kustomer-ios", package: "kustomer-ios"),
                ],
                path: "Plugins/Kustomer"),
        .target(
                name: "ZendeskPlugin",
                dependencies:[
                    .target(name: "Forethought"),
                    .product(name: "ZendeskChatSDK", package: "chat_sdk_ios"),
                ],
                path: "Plugins/Zendesk"),
        .target(
                name: "IntercomPlugin",
                dependencies:[
                    .target(name: "Forethought"),
                    .product(name: "Intercom", package: "intercom-ios"),
                ],
                path: "Plugins/Intercom")
    ]
)
