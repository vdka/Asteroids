
import muse

struct Entity {

    var id: Int
    var position: V2
    var velocity: V2
    var direction: f32

    var kind: Kind

    enum Kind {
        case player(weaponCooldown: Int, isAccelerating: Bool)
        case exhaust(ticks: Int)
        case bullet(ticks: Int)

        case asteroid(size: Int, points: [V2])
    }

    init(position: V2, velocity: V2 = .zero, direction: f32 = 0, kind: Kind) {
        self.id = -1
        self.position = position
        self.velocity = velocity
        self.direction = direction
        self.kind = kind
    }
}

extension Entity.Kind {

    var startOffset: Int {
        return 1
    }

    mutating func basePtr() -> UnsafeMutableRawPointer {
        return withUnsafeMutableBytes(of: &self) { bp in
            return bp.baseAddress!.advanced(by: 1)
        }
    }
}

extension Entity {

    var Player: (weaponCooldown: Int, isAccelerating: Bool) {
        get {
            guard case .player(let tuple) = kind else {
                fatalError()
            }
            return tuple
        }
        set {
            self.kind = .player(weaponCooldown: newValue.weaponCooldown, isAccelerating: newValue.isAccelerating)
        }
    }

    var ExhaustTicks: Int {
        get {
            guard case .exhaust(let tuple) = kind else {
                fatalError()
            }
            return tuple
        }
        set {
            self.kind = .exhaust(ticks: newValue)
        }
    }

    var BulletTicks: Int {
        get {
            guard case .bullet(let tuple) = kind else {
                fatalError()
            }
            return tuple
        }
        set {
            self.kind = .bullet(ticks: newValue)
        }
    }
}

// TODO(vdka): we need the game state here too.
func update(_ entity: inout Entity, _ gameState: inout GameState) {

    let worldLeftBound  = gameState.camera.x - gameState.camera.width  / 2
    let worldRightBound = gameState.camera.x + gameState.camera.width  / 2
    let worldUpperBound = gameState.camera.x + gameState.camera.height / 2
    let worldLowerBound = gameState.camera.x - gameState.camera.height / 2

    func wrap(_ n: f32, lower: f32, upper: f32) -> f32 {

        if n >= upper {
            return lower
        }
        if n <= lower {
            return upper
        }

        return n
    }

    entity.position.x = wrap(entity.position.x, lower: worldLeftBound, upper: worldRightBound)
    entity.position.y = wrap(entity.position.y, lower: worldLowerBound, upper: worldUpperBound)

    entity.position += entity.velocity * f32(GetFrameTime())

    if IsKeyDown(KeyN), gameState.rng.boundedNext(20) == 0 {
        var asteroid = makeAsteroid(size: 1, rng: &gameState.rng)

        gameState.add(&asteroid)
    }

    switch entity.kind {
    case .player:
        if IsKeyDown(KeyD) {

            entity.direction -= 6 * f32(GetFrameTime())
        }
        if IsKeyDown(KeyA) {

            entity.direction += 6 * f32(GetFrameTime())
        }
        if IsKeyDown(KeyW) {

            entity.Player.isAccelerating = true

            let facingVector = V2.up.rotated(by: entity.direction)
            var exhaust = Entity(
                position: entity.position + (-facingVector * 3),
                velocity: -facingVector * 100,
                direction: entity.direction,
                kind: .exhaust(ticks: 0)
            )
            gameState.add(&exhaust)

            entity.velocity += V2.up.rotated(by: entity.direction) * 15 * f32(GetFrameTime())
        } else {
            entity.Player.isAccelerating = false
        }
        if IsKeyDown(KeyS) {
            entity.velocity *= 0.99 * (1 - f32(GetFrameTime()))
        }
        if IsKeyDown(KeySpace), entity.Player.weaponCooldown == 0 {

            entity.Player.weaponCooldown = 8

            let facingVector = V2.up.rotated(by: entity.direction)
            var bullet = Entity(
                position: entity.position + (facingVector * 4),
                velocity: facingVector * 100,
                direction: entity.direction,
                kind: .bullet(ticks: 0)
            )
            gameState.add(&bullet)
        }
        if IsKeyDown(KeyR) {
            entity.position = .zero
        }

        if entity.Player.weaponCooldown > 0 {
            entity.Player.weaponCooldown -= 1
        }

    case .exhaust:
        if entity.ExhaustTicks > 10 {
            gameState.remove(&entity)
        } else {
            entity.ExhaustTicks += 1
            entity.velocity *= 0.98
        }

    case .bullet:
        if entity.BulletTicks > 100 {
            gameState.remove(&entity)
        } else {
            entity.BulletTicks += 1
        }

    case .asteroid:
        break
        // collision detections.
    }

    entity.direction = wrap(entity.direction, lower: 0, upper: TAU)
}

func draw(_ entity: Entity) {

    switch entity.kind {
    case .player:
        var t1 = V2(x: entity.position.x, y: entity.position.y + 4)
        var t2 = V2(x: entity.position.x - 2, y: entity.position.y - 3)
        var t3 = V2(x: entity.position.x + 2, y: entity.position.y - 3)

        t1 = t1.rotated(by: entity.direction, around: entity.position)
        t2 = t2.rotated(by: entity.direction, around: entity.position)
        t3 = t3.rotated(by: entity.direction, around: entity.position)

        FillTri(t1, t2, t3, .white)

    case .exhaust(let tick):
        let tick = f32(tick)
        let intensity = 1 / (tick + 1)
        var t1 = V2(x: entity.position.x, y: entity.position.y - 3 + (intensity))
        var t2 = V2(x: entity.position.x - 1.5 * sqrt(intensity), y: entity.position.y + (tick / 10))
        var t3 = V2(x: entity.position.x + 1.5 * sqrt(intensity), y: entity.position.y + (tick / 10))

        t1 = t1.rotated(by: entity.direction, around: entity.position)
        t2 = t2.rotated(by: entity.direction, around: entity.position)
        t3 = t3.rotated(by: entity.direction, around: entity.position)

        let r = intensity
        let g = (intensity * intensity) * (200 / 255)
        let b = (intensity * intensity) * (225 / 255)
        let color = Color(r: r, g: g, b: b)
        FillTri(t1, t2, t3, color)

    case .bullet:
//        DrawPoint(entity.position.x, entity.position.y, .white)
        FillCircle(entity.position, 0.5, .white)

    case .asteroid(_, let points):

        var prevPoint = entity.position + points.last!
        for point in points {
            let point = entity.position + point

            DrawLine(prevPoint.x, prevPoint.y, point.x, point.y, .white)
            prevPoint = point
        }
    }
}
