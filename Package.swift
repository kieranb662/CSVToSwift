// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CSVToSwift",
    platforms: [
        .macOS(.v10_14),
    ],
    products: [
        .executable(
            name: "CSVToSwift",
            targets: ["CSVToSwift"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser",
               from: "0.0.1"
        ),
    ],
    targets: [
        .target(
            name: "CSVToSwift",
            dependencies: ["ArgumentParser"]),
    ]
)
