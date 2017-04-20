
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

struct GameState {
    var currStateSize: Int
    var camera: Camera
    var museState: OpaquePointer

    var entities: [Entity] = []

    init(camera: Camera) {
        self.currStateSize = MemoryLayout<GameState>.size
        self.camera = camera
        self.museState = GetState()
    }
}

@_silgen_name("preReload")
func preReload(statePtr: UnsafeMutablePointer<GameState>) -> Void {
    // TODO(vdka): Handle GameState size changes. These would be bad. Very, very bad.
    //   I think we will need a serialization format in order to persist and read back values
    //   Alternatively we could limit ourselves to adding state things to the end of the GameState
    statePtr.pointee.museState = GetState()
}

@_silgen_name("postReload")
func postReload(statePtr: UnsafeMutablePointer<GameState>) -> Void {
    SetState(statePtr.pointee.museState)
}

@_silgen_name("setup")
func setup() -> UnsafeMutablePointer<GameState> {

    InitWindow(640, 480, "Asteroids")

    let camera = Camera(x: 0, y: 0, width: 3.2, height: 2.4)
    var gameState = GameState(camera: camera)

    SetCamera(camera)

    let player = Entity(kind: EntityKindPlayer, position: .zero, velocity: .zero, direction: 0)
    gameState.entities.append(player)

    let memory = UnsafeMutablePointer<GameState>.allocate(capacity: 1)
    memory.pointee = gameState

    return memory
}

@_silgen_name("update")
func update(_ memory: UnsafeMutablePointer<GameState>) {

    var gameState = memory.pointee
    defer { memory.pointee = gameState }

    if WindowShouldClose() {
        gameState.currStateSize = 0

        //
        // Deinitialize any resources
        //
        CloseWindow()

        return
    }

    var player = gameState.entities[0]
    if IsKeyDown(KeyD) {
        gameState.camera.x += 1 * Float(GetFrameTime())
        player.direction -= 0.1
    }
    if IsKeyDown(KeyA) {

        player.direction += 0.1
        gameState.camera.x -= 1 * Float(GetFrameTime())
    }
    if IsKeyDown(KeyW) {
        gameState.camera.y += 1 * Float(GetFrameTime())

        let flame = Entity(kind: EntityKindExhaust, position: player.position, velocity: player.velocity, direction: player.direction)
        gameState.entities.append(flame)
    }
    if IsKeyDown(KeyS) {
        gameState.camera.y -= 1 * Float(GetFrameTime())
    }


    gameState.camera.width  = 320
    gameState.camera.height = 240
    SetCamera(gameState.camera)

    let mouse = WorldToCamera(GetMousePosition())

    if IsMouseButtonDown(MouseButtonLeft) {
        pred = true
    }
    // TODO(vdka): Zoom

    BeginFrame()
    ClearBackground(.black)

    for entity in gameState.entities {

        draw(entity)
    }

    EndFrame()
}
