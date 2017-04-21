
import Darwin.C
import Foundation

func curTime() -> Double {

    var tv = timeval()
    gettimeofday(&tv, nil)

    return Double(tv.tv_sec) + Double(tv.tv_usec) / 1000000
}

// Just used for an address.
var variable: Bool = false

// TODO(vdka): Get the current executing file directory using Dl_info for use as executablePath
func getExecutablePath() -> String {
    var info = dl_info()

    // First get the address of _main

    withUnsafePointer(to: &variable) {

        guard dladdr($0, &info) != 0 else {
            fatalError("Failed to get self")
        }
    }

    let path = String(cString: info.dli_fname)

    return "/" + Array(path.characters.split(separator: "/").dropLast()).map(String.init).joined(separator: "/")
}

public final class DynamicLib {

    public var path: String
    private var handle: UnsafeMutableRawPointer?
    public var lastReadTime: Int?

    public var lastWriteTime: Int? {

        var fileStats = stat()
        guard stat(path, &fileStats) == 0 else { return nil }
        return fileStats.st_mtimespec.tv_sec
    }

    public init(path: String) {

        let executablePath = getExecutablePath()

        self.path = path.replacingOccurrences(of: "@executable_path", with: executablePath)
    }

    deinit {
        unload()
    }

    public func load() {
        guard dlopen_preflight(path) else {
            fatalError(dlError)
        }

        handle = dlopen(path, RTLD_LAZY)

        guard handle != nil else {
            fatalError(dlError)
        }

        lastReadTime = lastWriteTime
    }

    public func unload() {

        guard let handle = handle else {
            fatalError(dlError)
        }

        guard dlclose(handle) == 0 else {
            fatalError(dlError)
        }

        self.handle = nil
    }

    public var shouldReload: Bool {
        return lastWriteTime != lastReadTime
    }

    public func reload() {

        let startTime = curTime()

        // only reload if the last write did not occur when the last read did.
        guard shouldReload else { return }

        print("Reloading \(path.characters.split(separator: "/").last.flatMap(String.init)!)")

        unload()
        while lastWriteTime == nil && curTime() - startTime < 1 {
            usleep(1)
        }
        load()

        print("Reload successful! \(time(nil))")
    }

    public func unsafeSymbol<T>(named name: String, withSignature: T.Type) -> T? {

        guard let symbol = symbol(named: name) else { return nil }

        return unsafeBitCast(symbol, to: T.self)
    }

    public func symbol(named name: String) -> UnsafeMutableRawPointer? {
        guard handle != nil else { return nil }

        let symbol = dlsym(handle, name)

        return symbol
    }

    var dlError: String {
        return String(cString: dlerror())
    }
}
