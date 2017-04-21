
import muse

extension Color: ExpressibleByIntegerLiteral {

    public init(integerLiteral value: UInt32) {
        self = unsafeBitCast(value.bigEndian, to: Color.self)
    }

    public init(rgba: UInt32) {
        self.rgba = rgba.bigEndian
    }

    static var white: Color = 0xffffffff
    static var black: Color = 0x000000ff
    static var red:   Color = 0xff0000ff
    static var green: Color = 0x00ff00ff
    static var blue:  Color = 0x0000ffff
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
