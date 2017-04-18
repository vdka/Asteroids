// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "Asteroids",
    targets: [
      Target(name: "muse"),
      Target(name: "Asteroids", dependencies: ["muse"])
    ]
)

let lib = Product(name: "muse", type: .Library(.Dynamic), modules: "muse")

