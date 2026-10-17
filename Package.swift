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
            name: "GlassBackground",
            targets: ["GlassBackground"]
        ),
        .library(
            name: "MetalEngine",
            targets: ["MetalEngine"]
        ),
    ],
    targets: [
        .target(
            name: "Display",
            dependencies: ["UIKitRuntimeUtils"]
        ),
        .target(
            name: "DustEffect",
            dependencies: ["MetalEngine"]
        ),
        .target(
            name: "GlassBackground",
            dependencies: ["Display", "MeshTransform"]
        ),
        .target(
            name: "MeshTransform",
            dependencies: ["MeshTransformApi"]
        ),
        .target(
            name: "MeshTransformApi"
        ),
        .target(
            name: "MetalEngine",
            dependencies: ["Display", "ShelfPack"]
        ),
        .target(
            name: "ShelfPack"
        ),
        .target(
            name: "UIKitRuntimeUtils"
        ),
    ]
)
