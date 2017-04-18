// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "Asteroids",
    targets: [
      Target(name: "muse"),
      Target(name: "Asteroids", dependencies: [.Target(name: "muse")]),
      Target(name: "LoopStatic", dependencies: [.Target(name: "Asteroids")]),
      Target(name: "LoopDynamic"),
    ]
)

let libAsteroids = Product(name: "Asteroids", type: .Library(.Dynamic), modules: "Asteroids")

products.append(libAsteroids)

