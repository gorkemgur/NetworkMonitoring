// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkMonitoring",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "NetworkMonitoring",
            targets: ["NetworkMonitoring"]),
    ],
    targets: [
        .target(
            name: "NetworkMonitoring"),
        .testTarget(
            name: "NetworkMonitoringTests",
            dependencies: ["NetworkMonitoring"]),
    ]
)
