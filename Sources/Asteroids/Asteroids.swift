

import muse

let sourceRoot = "/" + #file.characters.split(separator: "/").dropLast(3).map(String.init).joined(separator: "/")

var pred = false

func makeAsteroid(size: Int, rng: inout PCGRand32) -> Entity {

    var points: [V2] = []

    let minRadius: f32 = 14
    let maxRadius: f32 = 20

    let nSides: f32 = rng.boundedNext(5) + 10
    let granularity: f32 = TAU / nSides

    let minVariation: f32 = granularity + 0.2 * TAU
    let maxVariation: f32 = 0.28 * TAU

    var angle: f32 = 0
    while angle <= TAU {

        let angleVariance = rng.boundedNext(maxVariation - minVariation) + minVariation / 2
        let angleFinal = min(angle + angleVariance, TAU)

        let radius = rng.boundedNext(maxRadius - minRadius) + minRadius / 2

        let x = sin(angleFinal) * radius
        let y = -cos(angleFinal) * radius

        points.append(V2(x, y))

        angle += granularity
    }

    let minVelocity: f32 = 10
    let maxVelocity: f32 = 50
    let velocity: f32    = rng.boundedNext(maxVelocity - minVelocity) + minVelocity
    let direction: f32   = rng.boundedNext(TAU)

    return Entity(position: V2(-130, -120), velocity: V2.up.rotated(by: direction) * velocity, direction: direction, kind: .asteroid(size: size, points: points))
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

    let camera = Camera(x: 0, y: 0, width: 320, height: 240)
    var gameState = GameState(camera: camera)

    SetCamera(camera)

    let player = Entity(position: .zero, velocity: .zero, direction: 0, kind: .player(timeToRespawn: 0, weaponCooldown: 0, isAccelerating: false))
    gameState.entities.append(player)

    let memory = UnsafeMutablePointer<GameState>.allocate(capacity: 1)
    memory.initialize(to: gameState)

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
        CloseWindow()

        return
    }

    if IsKeyDown(KeyN), gameState.rng.boundedNext(1.0) < 0.1 {
        let asteroid = makeAsteroid(size: 1, rng: &gameState.rng)

        gameState.entities.append(asteroid)
    }
    if IsKeyDown(KeyR) {
        var index = gameState.entities.startIndex
        while index < gameState.entities.endIndex {

            if case .asteroid = gameState.entities[index].kind {
                gameState.entities.remove(at: index)
            } else {
                index = gameState.entities.index(after: index)
            }
        }
    }

    let mouse = WorldToCamera(GetMousePosition())

    if IsMouseButtonDown(MouseButtonLeft) {
        pred = true
    }

    for index in gameState.entities.indices {
        update(&gameState.entities[index], &gameState)
    }
    for index in gameState.particles.indices {
        update(&gameState.particles[index], &gameState)
    }

    gameState.entities.append(contentsOf: gameState.newEntities)
    gameState.particles.append(contentsOf: gameState.newParticles)

    gameState.newEntities.removeAll(keepingCapacity: true)
    gameState.newParticles.removeAll(keepingCapacity: true)

    BeginFrame()
    ClearBackground(.black)

    FillCircle(mouse, 10, .red)

    gameState.entities.forEach(draw)
    gameState.particles.forEach(draw)

    EndFrame()

    for (index, entity) in gameState.entities.enumerated().reversed() {
        if entity.flags.contains(.dead) {
            gameState.entities.remove(at: index)
        }
    }

    for (index, particle) in gameState.particles.enumerated().reversed() {
        if particle.remainingTicks <= 0 {
            gameState.particles.remove(at: index)
        }
    }
}
