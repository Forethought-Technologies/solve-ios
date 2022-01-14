import PackageDescription
let package = Package(
    name: "Forethought",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "Forethought", 
            targets: ["Forethought"])
    ],
    targets: [
        .binaryTarget(
            name: "Forethought", 
            path: "Forethought.xcframework")
    ]
)