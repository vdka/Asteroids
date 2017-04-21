
import muse

extension V2 {

    static let zero  = V2(x: 0, y: 0)
    static let up    = V2(x: 0, y: 1)
    static let down  = V2(x: 0, y: -1)
    static let right = V2(x: 1, y: 0)
    static let left  = V2(x: -1, y: 0)

    var lengthSquared: f32 {
        return x * x + y * y
    }

    var length: f32 {
        return sqrt(lengthSquared)
    }

    var inverse: V2 {
        return -self
    }

    init(_ x: f32, _ y: f32) {
        self.init(x: x, y: y)
    }

    init(_ v: [f32]) {
        assert(v.count == 2, "array must contain 2 elements, contained \(v.count)")

        x = v[0]
        y = v[1]
    }

    func toArray() -> [f32] {
        return [x, y]
    }

    func dot(_ v: V2) -> f32 {
        return x * v.x + y * v.y
    }

    func cross(_ v: V2) -> f32 {
        return x * v.y - y * v.x
    }

    func normalized() -> V2 {
        let lengthSquared = self.lengthSquared
        if lengthSquared ~= 0 || lengthSquared ~= 1 {
            return self
        }
        return self / sqrt(lengthSquared)
    }

    func rotated(by radians: f32) -> V2 {
        let cs = cos(radians)
        let sn = sin(radians)
        let dx: Float = x * cs - y * sn
        let dy: Float = x * sn + y * cs
        return V2(dx, dy)
    }

    func rotated(by radians: f32, around pivot: V2) -> V2 {
        return (self - pivot).rotated(by: radians) + pivot
    }

    func angle(with v: V2) -> f32 {
        if self == v {
            return 0
        }

        let t1 = normalized()
        let t2 = v.normalized()
        let cross = t1.cross(t2)
        let dot = max(-1, min(1, t1.dot(t2)))

        return atan2(cross, dot)
    }

    func interpolated(with v: V2, t: f32) -> V2 {
        return self + (v - self) * t
    }

    var description: String {
        return "(\(x), \(y))"
    }

    static prefix func - (v: V2) -> V2 {
        return V2(-v.x, -v.y)
    }

    static func + (lhs: V2, rhs: V2) -> V2 {
        return V2(lhs.x + rhs.x, lhs.y + rhs.y)
    }

    static func - (lhs: V2, rhs: V2) -> V2 {
        return V2(lhs.x - rhs.x, lhs.y - rhs.y)
    }

    static func * (lhs: V2, rhs: V2) -> V2 {
        return V2(lhs.x * rhs.x, lhs.y * rhs.y)
    }

    static func * (lhs: V2, rhs: f32) -> V2 {
        return V2(lhs.x * rhs, lhs.y * rhs)
    }

    static func / (lhs: V2, rhs: V2) -> V2 {
        return V2(lhs.x / rhs.x, lhs.y / rhs.y)
    }

    static func / (lhs: V2, rhs: f32) -> V2 {
        return V2(lhs.x / rhs, lhs.y / rhs)
    }

    static func += (left: inout V2, right: V2) {
        left = left + right
    }

    static func -= (left: inout V2, right: V2) {
        left = left - right
    }

    static func *= (left: inout V2, right: V2) {
        left = left * right
    }

    static func *= (left: inout V2, right: f32) {
        left = left * right
    }

    static func /= (left: inout V2, right: V2) {
        left = left / right
    }
    
    static func /= (left: inout V2, right: f32) {
        left = left / right
    }
    
    static func == (lhs: V2, rhs: V2) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    static func ~= (lhs: V2, rhs: V2) -> Bool {
        return lhs.x ~= rhs.x && lhs.y ~= rhs.y
    }
}

