

let baseDir = "/" + Array(#file.characters.split(separator: "/").dropLast(3)).map(String.init).joined(separator: "/")

let buildDir = baseDir


let gameEngine = DynamicLib(path: buildDir + "/bin/libAsteroids.dylib")
gameEngine.load()

var shouldQuit = false

typealias Byte = UInt8

// If return nil there was an error during initialization
typealias LoadFunction   = @convention(c) () -> UnsafeMutablePointer<Byte>?
typealias OnLoadFunction = @convention(c) (UnsafeMutablePointer<Byte>?) -> Void
typealias UpdateFunction = @convention(c) (UnsafeMutablePointer<Byte>?) -> Bool

let setup = gameEngine.unsafeSymbol(named: "setup", withSignature: LoadFunction.self)

var memory = setup?()

guard memory != nil else { fatalError("Call to initialize function failed") }

while (!shouldQuit) {

  if gameEngine.shouldReload {

    gameEngine.reload()

    let onLoad = gameEngine.unsafeSymbol(named: "onLoad", withSignature: OnLoadFunction.self)

    onLoad?(memory)
  }

  guard let loop = gameEngine.symbol(named: "update") else {
    print("update function missing")
    continue
  }

  shouldQuit = unsafeBitCast(loop, to: UpdateFunction.self)(memory)
}

print("Did quit cleanly!")
