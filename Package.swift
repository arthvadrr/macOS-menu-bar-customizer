// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Menu Bar Customizer",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "Menu Bar Customizer", 
            targets: ["Menu Bar Customizer"]
        )
    ],
    targets: [
        .executableTarget(
            name: "Menu Bar Customizer",
            dependencies: [],
            path: ""
        )
    ]
);