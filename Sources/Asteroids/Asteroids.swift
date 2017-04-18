
import muse

let sourceRoot = "/" + #file.characters.split(separator: "/").dropLast(3).map(String.init).joined(separator: "/")

var pred = false

func raycast(from rayStart: V2, to rayEnd: V2, _ seg1: V2, seg2: V2) -> V2 {

    let rayDelta = V2(x: rayEnd.x - rayStart.x, y: rayEnd.y - rayStart.y)
    let scale = V2(x: 1 / rayDelta.x, y: 1 / rayDelta.y)
    var sign = V2()
    sign.x = copysignf(1, scale.x)
    sign.y = copysignf(1, scale.y)

    var nearTime = V2()
    nearTime.x = (seg1.x * sign.x - rayStart.x) * scale.x
    nearTime.y = (seg1.y * sign.y - rayStart.y) * scale.y

    var farTime = V2()
    farTime.x = (seg2.x * sign.x - rayStart.x) * scale.x
    farTime.y = (seg2.y * sign.y - rayStart.y) * scale.y

    if nearTime.x > farTime.y || nearTime.y > farTime.x {
        return rayEnd
    }

    let near = nearTime.x > nearTime.y ? nearTime.x : nearTime.y
    let far  = farTime.x  > farTime.y  ? farTime.x  : farTime.y

    if near >= 1 || far <= 0 {
        // Collision does not lay upon the segment
        return rayEnd
    }

    if pred {
        print(rayDelta)
        print(sign)
        print("near time: ", terminator: "")
        print(nearTime)
        print("far  time: ", terminator: "")
        print(farTime)
        pred = false
    }

    var collision = V2()
    collision.x = rayDelta.x * near
    collision.y = rayDelta.y * near

    collision.x += rayStart.x
    collision.y += rayStart.y

    return collision
}

extension Color: ExpressibleByIntegerLiteral {

    public init(integerLiteral value: UInt32) {
        self = unsafeBitCast(value.bigEndian, to: Color.self)
    }

    public init(rgba: UInt32) {
        self.rgba = rgba.bigEndian
    }

    static var white: Color = 0xffffffff
    static var black: Color = 0x000000ff
    static var green: Color = 0x00ff00ff
    static var blue:  Color = 0x0000ffff
}

extension V2: CustomStringConvertible {
    static let zero = V2(x: 0, y: 0)

    public var description: String {
        return "(\(x), \(y))"
    }
}

struct GameState {
    var shouldQuit: Bool
    var camera: Camera
}


func write<T>(_ value: inout T, to destinationPointer: UnsafeMutableRawPointer) {

    withUnsafeMutablePointer(to: &value) { valuePointer in

        destinationPointer.copyBytes(from: valuePointer, count: MemoryLayout<T>.size)
    }
}

@_silgen_name("setup")
public func setup() -> UnsafeMutableRawPointer {

    InitWindow(640, 480, "Asteroids")

    let camera = Camera(x: 0, y: 0, width: 3.2, height: 2.4)
    var gameState = GameState(shouldQuit: WindowShouldClose(), camera: camera)

    SetCamera(camera)

    let memory = UnsafeMutableRawPointer.allocate(bytes: 1024, alignedTo: 1)

    write(&gameState, to: memory)

    return memory
}

@_silgen_name("update")
public func update(_ memory: UnsafeMutableRawPointer) {

    var gameState = memory.bindMemory(to: GameState.self, capacity: 1).pointee
    defer { write(&gameState, to: memory) }

    if WindowShouldClose() {
        gameState.shouldQuit = true

        //
        // Deinitialize any resources
        //
        CloseWindow()

        return
    }


    if IsKeyDown(KeyD) { gameState.camera.x += 1 * Float(frameTime) }
    if IsKeyDown(KeyA) { gameState.camera.x -= 1 * Float(frameTime) }
    if IsKeyDown(KeyW) { gameState.camera.y += 1 * Float(frameTime) }
    if IsKeyDown(KeyS) { gameState.camera.y -= 1 * Float(frameTime) }

    SetCamera(gameState.camera)

    let mouse = WorldToCamera(GetMousePosition())

    if IsMouseButtonDown(MouseButtonLeft) {
        pred = true
    }
    // TODO(vdka): Zoom

    let endRay = raycast(from: V2.zero, to: mouse, V2(x: 0.5, y: 0.5), seg2: V2(x: 0.5, y: 1))

    BeginFrame()
    ClearBackground(.white)

    //    FillTriXY(0, 0, 0, 0.5, 0.25, 0.25, 0xff0000ff)
    //    FillTriXY(0, 0, 0.25, 0.25, 0.5, 0, 0x00ff00ff)
    //    FillTriXY(0.5, 0, 0.5, 0.5, 0, 0.5, 0x0000ffff)

    FillQuadCentered(V2(x: 0.5, y: 0.75), V2(x: 0.05, y: 0.5),   .black)
    FillQuadCentered(V2(x: -0.5, y: -0.75), V2(x: 0.05, y: 0.5), .black)
    FillQuadCentered(V2(x: 0.5, y: -0.75), V2(x: 0.05, y: 0.5),  .black)
    FillQuadCentered(V2(x: -0.5, y: 0.75), V2(x: 0.05, y: 0.5),  .black)
    DrawLine(0, 0, endRay.x, endRay.y, 0x0000ffff)

    //    FillQuadCentered(V2(x: -0.5, y: 0.75), V2(x: 0.1, y: 0.5), .black)
    //    DrawLine(0.5, 0.5, 0.5, 1.1, .black)

    FillCircle(mouse, 0.05, 0x0000ffff)

    EndFrame()
}
