// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "StudyplusSDK",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "StudyplusSDK",
            targets: ["StudyplusSDK"]
        )
    ],
    targets: [
        .target(
            name: "StudyplusSDK",
            path: "Lib/StudyplusSDK"
        )
    ]
)
