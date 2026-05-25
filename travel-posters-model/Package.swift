// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "travel-posters-model",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14), .tvOS(.v17), .watchOS(.v10), .macCatalyst(.v17)],
    products: [
        .library(name: "TravelPostersModel", type: .dynamic, targets: ["TravelPostersModel"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.9.2"),
        .package(url: "https://source.skip.tools/skip-model.git", from: "1.0.0"),
        .package(url: "https://source.skip.tools/skip-fuse.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "TravelPostersModel",
            dependencies: [
                .product(name: "SkipFuse", package: "skip-fuse"), 
                .product(name: "SkipModel", package: "skip-model")
            ],
            resources: [.process("Resources")],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "TravelPostersModelTests",
            dependencies: [
                "TravelPostersModel",
                .product(name: "SkipTest", package: "skip")
            ],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
