

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

func makeAsteroid(size: Int, rng: inout PCGRand32) -> Entity {

    var points: [V2] = []

    let minRadius: f32 = 14
    let maxRadius: f32 = 20

    let granularity: f32 = 0.1 * TAU

    let minVariation: f32 = 0.15 * TAU
    let maxVariation: f32 = 0.28 * TAU

    var angle: f32 = 0
    while angle <= TAU - maxVariation {

        let angleVariance = rng.boundedNext(maxVariation - minVariation) + minVariation
        let angleFinal = angle + angleVariance

        let radius = rng.boundedNext(maxRadius - minRadius) + minRadius

        let x = sin(angleFinal) * radius
        let y = -cos(angleFinal) * radius

        points.append(V2(x, y))

        angle += TAU / granularity
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

    let player = Entity(position: .zero, velocity: .zero, direction: 0, kind: .player(weaponCooldown: 0, isAccelerating: false))
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

    if IsKeyDown(KeyN), gameState.rng.boundedNext(20) == 0 {
        let asteroid = makeAsteroid(size: 1, rng: &gameState.rng)

        gameState.entities.append(asteroid)
    }

    let mouse = WorldToCamera(GetMousePosition())

    if IsMouseButtonDown(MouseButtonLeft) {
        pred = true
    }

    for (index, var entity) in gameState.entities.enumerated() {
        update(&entity, &gameState)
        gameState.entities[index] = entity
    }

    for (index, var particle) in gameState.particles.enumerated() {
        update(&particle, &gameState)
        gameState.particles[index] = particle
    }

    BeginFrame()
    ClearBackground(.black)

    FillCircle(mouse, 10, .red)

    for entity in gameState.entities {
        draw(entity)
    }
    for particle in gameState.particles {
        draw(particle)
    }

    EndFrame()

    var nextEntities = Array<Entity>()
    nextEntities.reserveCapacity(gameState.entities.count)
    for entity in gameState.entities {
        if !entity.flags.contains(.dead) {
            nextEntities.append(entity)
        }
    }
    gameState.entities = nextEntities

    var nextParticles = Array<Particle>()
    nextParticles.reserveCapacity(gameState.particles.count)
    for particle in gameState.particles {
        if particle.remainingTicks > 0 {
            nextParticles.append(particle)
        }
    }
    gameState.particles = nextParticles
}
