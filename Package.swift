// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "TelegramHighlights",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "TelegramHighlights",
            targets: ["TelegramHighlights"]
        ),
    ],
    targets: [
        .target(
            name: "TelegramHighlights"
        ),
    ]
)
