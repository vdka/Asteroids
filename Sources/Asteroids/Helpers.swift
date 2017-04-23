
import muse

extension Color: ExpressibleByIntegerLiteral {

    public init(integerLiteral value: UInt32) {
        self = unsafeBitCast(value.bigEndian, to: Color.self)
    }

    init(rgba: UInt32) {
        self.rgba = rgba.bigEndian
    }

    init(r: Float, g: Float, b: Float, a: Float = 1.0) {
        self.r = UInt8(255 * max(min(r, 1), 0))
        self.g = UInt8(255 * max(min(g, 1), 0))
        self.b = UInt8(255 * max(min(b, 1), 0))
        self.a = UInt8(255 * max(min(a, 1), 0))
    }

    static var white: Color = 0xffffffff
    static var black: Color = 0x000000ff
    static var red:   Color = 0xff0000ff
    static var green: Color = 0x00ff00ff
    static var blue:  Color = 0x0000ffff
}

func clamp(_ n: f32, lower: f32, upper: f32) -> f32 {
    return max(lower, min(n, upper))
}

func wrap(_ n: f32, lower: f32, upper: f32) -> f32 {

    if n >= upper {
        return lower
    }
    if n <= lower {
        return upper
    }

    return n
}

func dumpMemory<T>(of input: T) {

    var input = input

    withUnsafeBytes(of: &input) { buffer in

        for (i, v) in buffer.enumerated() {
            if i % 8 == 0 && i != 0 { print("\n", terminator: "") }

            let hexByte = String(v, radix: 16)

            // Pad the output to be 2 characters wide
            if hexByte.characters.count == 1 { print("0", terminator: "") }
            print(hexByte, terminator: " ")
        }
        print("")
    }
}
