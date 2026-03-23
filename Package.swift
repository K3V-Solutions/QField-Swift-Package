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
            url: "https://github.com/K3V-Solutions/QField-Swift-Package/releases/download/0.0.6/QFieldEmbedded.xcframework.zip",
            checksum: "ea4422404fa73164e135cf1de64f86682f520b395ababe1f185efd989381a3c8"
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
