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
            url: "https://github.com/K3V-Solutions/QField-Swift-Package/releases/download/0.0.7/QFieldEmbedded.xcframework.zip",
            checksum: "ab7e9a62e6830f5073aec50432d95fad36c18ad40e482de2d5c6ffe19ec49317"
        ),
        
        .target(
            name: "QField",
            dependencies: [
                .target(name: "QFieldEmbedded")
            ],
            path: "Sources/QFieldMap",
            publicHeadersPath: ".",
			linkerSettings: [
				.linkedFramework("Foundation")
			]
        ),
    ]
)
