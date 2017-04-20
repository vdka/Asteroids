
let lib = DynamicLib(path: "@executable_path/Asteroids")
lib.load()

// If return nil there was an error during initialization
typealias LoadFunction   = @convention(c) () -> UnsafeMutableRawPointer?
typealias UpdateFunction = @convention(c) (UnsafeMutableRawPointer) -> Void

let setup = lib.unsafeSymbol(named: "setup", withSignature: LoadFunction.self)

var memory = setup?()

guard var memory = memory else { fatalError("Call to initialize function failed") }

//
// The start of the persisted memory must be the an Int representing the size of the currently
//   persisted memory. If the size is 0 then it's the lib indicating it is done.
//
while memory.assumingMemoryBound(to: Int.self).pointee != 0 {

    let size = memory.assumingMemoryBound(to: Int.self).pointee

    if lib.shouldReload {

        typealias PreFunction  = @convention(c) (UnsafeMutableRawPointer) -> Void
        typealias PostFunction = @convention(c) (UnsafeMutableRawPointer) -> Void

        //
        // Notify the dylib that it is about to be unloaded allowing it to update the persisted memory
        //
        let pre = lib.unsafeSymbol(named: "preReload", withSignature: PreFunction.self)
        pre?(memory)

        //
        // Unload then reload the code
        //
        lib.reload()

        //
        // Notify the dylib that it has just be reloaded allowing it to reset global state using the persisted memory
        //
        let post = lib.unsafeSymbol(named: "postReload", withSignature: PostFunction.self)
        post?(memory)
    }

    guard let loop = lib.unsafeSymbol(named: "update", withSignature: UpdateFunction.self) else {
        print("update function missing")
        continue
    }

    loop(memory)
}

print("Did quit cleanly!")
