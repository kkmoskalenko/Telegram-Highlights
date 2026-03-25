// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "TelegramHighlights",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "DustEffect",
            targets: ["DustEffect"]
        ),
        .library(
            name: "MetalEngine",
            targets: ["MetalEngine"]
        ),
    ],
    targets: [
        .target(
            name: "Display"
        ),
        .target(
            name: "DustEffect",
            dependencies: ["MetalEngine"]
        ),
        .target(
            name: "MetalEngine",
            dependencies: ["Display", "ShelfPack"]
        ),
        .target(
            name: "ShelfPack"
        ),
    ]
)
