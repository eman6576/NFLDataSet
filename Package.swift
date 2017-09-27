// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NFLDataSet",
    dependencies: [
        .package(url: "https://github.com/yaslab/CSV.swift.git", from: "2.1.0"),
        .package(url: "https://github.com/tid-kijyun/Kanna.git", from: "2.2.1")
    ],
    targets: [
        .target(
            name: "NFLDataSet",
            dependencies: ["NFLDataSetLib"]),
        .target(
            name: "NFLDataSetLib",
            dependencies: ["CSV",
                           "Kanna"],
            path: "./Sources/NFLDataSetLib/")
    ]
)
