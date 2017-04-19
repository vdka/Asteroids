

let baseDir = "/" + Array(#file.characters.split(separator: "/").dropLast(3)).map(String.init).joined(separator: "/")

let buildDir = baseDir


let coreDylib     = DynamicLib(path: buildDir + "/bin/libAsteroids.dylib")
let coreFramework = DynamicLib(path: buildDir + "/bin/Asteroids.framework/Asteroids")

var currentCore: DynamicLib
switch (coreDylib.lastWriteTime, coreFramework.lastWriteTime) {
case let (dylib?, framework?) where dylib >= framework:
    currentCore = coreDylib

case let (dylib?, framework?) where dylib < framework:
    currentCore = coreFramework

case (_?, _):
    currentCore = coreDylib

case (_, _?):
    currentCore = coreFramework

case (_, _):
    fatalError("No code to load")
}

currentCore.load()

// If return nil there was an error during initialization
typealias LoadFunction   = @convention(c) () -> UnsafeMutableRawPointer?
typealias OnLoadFunction = @convention(c) (UnsafeMutableRawPointer) -> Void
typealias UpdateFunction = @convention(c) (UnsafeMutableRawPointer) -> Void

let setup = currentCore.unsafeSymbol(named: "setup", withSignature: LoadFunction.self)

var memory = setup?()

guard var memory = memory else { fatalError("Call to initialize function failed") }

while !memory.assumingMemoryBound(to: Bool.self).pointee {

    if currentCore.shouldReload {

        currentCore.reload()

        let onLoad = currentCore.unsafeSymbol(named: "onLoad", withSignature: OnLoadFunction.self)

        onLoad?(memory)
    }

    guard let loop = currentCore.symbol(named: "update") else {
        print("update function missing")
        continue
    }

    unsafeBitCast(loop, to: UpdateFunction.self)(memory)

    //
    // Set to most recently update lib
    switch (coreDylib.lastWriteTime, coreFramework.lastWriteTime) {
    case let (dylib?, framework?) where dylib >= framework:
        currentCore = coreDylib

    case let (dylib?, framework?) where dylib < framework:
        currentCore = coreFramework

    case (_?, _):
        currentCore = coreDylib

    case (_, _?):
        currentCore = coreFramework
        
    case (_, _):
        fatalError("No code to load")
    }
}

print("Did quit cleanly!")
