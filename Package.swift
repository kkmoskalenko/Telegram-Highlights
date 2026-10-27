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
            dependencies: ["UIKitRuntimeUtils"],
            exclude: ["provenance.json"]
        ),
        .target(
            name: "DustEffect",
            dependencies: ["MetalEngine"],
            exclude: ["provenance.json"]
        ),
        .target(
            name: "GlassBackground",
            dependencies: ["Display", "MeshTransform"],
            exclude: ["provenance.json"]
        ),
        .target(
            name: "MeshTransform",
            dependencies: ["MeshTransformApi"],
            exclude: ["provenance.json"]
        ),
        .target(
            name: "MeshTransformApi",
            exclude: ["provenance.json"]
        ),
        .target(
            name: "MetalEngine",
            dependencies: ["Display", "ShelfPack"],
            exclude: ["provenance.json"]
        ),
        .target(
            name: "ShelfPack",
            exclude: ["provenance.json"]
        ),
        .target(
            name: "UIKitRuntimeUtils",
            exclude: ["provenance.json"]
        ),
    ]
)
