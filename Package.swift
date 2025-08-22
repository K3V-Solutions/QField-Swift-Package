// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QField",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "QField",
            targets: ["QField"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .binaryTarget(
            name: "QFieldEmbedded",
            url: "https://github.com/K3V-Solutions/QField-Swift-Package/releases/download/0.0.2/QFieldEmbedded.xcframework.zip",
            checksum: "42e90312a3aac27eb590e7f3c721368ceb4a4351be5dc24c2a444f756b479f1e"
        ),
        
        .target(
            name: "QField",
            dependencies: [
                .target(name: "QFieldEmbedded")
            ],
            path: "Sources/QFieldWrapper",
            publicHeadersPath: ".",
        ),
    ]
)
