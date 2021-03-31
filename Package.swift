// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "StudyplusSDK-V2",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "StudyplusSDK-V2",
            targets: ["StudyplusSDK-V2"]
        )
    ],
    targets: [
        .target(
            name: "StudyplusSDK-V2",
            path: "Lib/StudyplusSDK"
        )
    ]
)
