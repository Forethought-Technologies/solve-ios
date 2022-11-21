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
    ],
    dependencies: [
        .package(url: "https://github.com/kustomer/kustomer-ios", from: "2.5.4"),
				.package(url: "https://github.com/zendesk/chat_sdk_ios", from: "2.11.0"),
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
							.product(name: "ZendeskChatSDK", package: "ZendeskChatSDK"),
						],
						path: "Plugins/Zendesk")					
    ]
)
