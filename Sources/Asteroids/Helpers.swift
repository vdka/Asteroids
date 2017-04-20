
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

extension V2: CustomStringConvertible {
    static let zero = V2(x: 0, y: 0)

    public var description: String {
        return "(\(x), \(y))"
    }
}
