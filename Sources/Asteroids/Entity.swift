
import muse

struct Entity {

    var position: V2
    var velocity: V2
    var direction: f32

    var flags: Flag
    var kind: Kind

    enum Kind {
        case player(weaponCooldown: Int, isAccelerating: Bool)
        case bullet(ticks: Int)

        case asteroid(size: Int, points: [V2])
    }

    struct Flag: OptionSet {
        var rawValue: UInt8

        static let none = Flag(rawValue: 0b00000000)
        static let dead = Flag(rawValue: 0b00000001)
    }

    init(position: V2, velocity: V2 = .zero, direction: f32 = 0, kind: Kind, flags: Flag = .none) {
        self.position = position
        self.velocity = velocity
        self.direction = direction
        self.kind = kind
        self.flags = flags
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

func update(_ entity: inout Entity, _ gameState: inout GameState) {

    let worldLeftBound  = gameState.camera.x - gameState.camera.width  / 2
    let worldRightBound = gameState.camera.x + gameState.camera.width  / 2
    let worldUpperBound = gameState.camera.x + gameState.camera.height / 2
    let worldLowerBound = gameState.camera.x - gameState.camera.height / 2

    entity.position.x = wrap(entity.position.x, lower: worldLeftBound, upper: worldRightBound)
    entity.position.y = wrap(entity.position.y, lower: worldLowerBound, upper: worldUpperBound)

    entity.position += entity.velocity * f32(GetFrameTime())

    switch entity.kind {
    case .player:

        let facingVector = V2.up.rotated(by: entity.direction)

        if IsKeyDown(KeyD) {

            entity.direction -= 6 * f32(GetFrameTime())
        }
        if IsKeyDown(KeyA) {

            entity.direction += 6 * f32(GetFrameTime())
        }
        if IsKeyDown(KeyW) {

            entity.Player.isAccelerating = true

            let numberOfExhaustParticlesToEmit = 3

            let rot = gameState.rng.boundedNext(0.1 * TAU) - (0.1 * TAU) / 2
            let exhaustVector = (-facingVector.rotated(by: rot) * 100) * gameState.rng.normallyDistributedNext(center: 1.0, maxWidth: 0.2)

            for _ in 0..<numberOfExhaustParticlesToEmit {

                let xOffset: Float = gameState.rng.boundedNext(shipAngle) - shipAngle / 2
                let position = (entity.position + (-facingVector * 3)).rotated(by: xOffset, around: entity.position)

                // use this to shift more red in the closer to the center something is.
                let r = gameState.rng.boundedNext(0.2) + 0.9
                let g = gameState.rng.boundedNext(0.4)
                let b = gameState.rng.boundedNext(0.4)

                let color = Color(r: r, g: g, b: b)

                let exhaustParticle = Particle(
                    position: position,
                    velocity: exhaustVector,
                    color: color,
                    remainingTicks: gameState.rng.boundedNext(20)
                )
                gameState.particles.append(exhaustParticle)
            }

            entity.velocity += V2.up.rotated(by: entity.direction) * 15 * f32(GetFrameTime())
        } else {
            entity.Player.isAccelerating = false
        }
        if IsKeyDown(KeyS) {
            entity.velocity *= 0.99 * (1 - f32(GetFrameTime()))
        }
        if IsKeyDown(KeySpace), entity.Player.weaponCooldown == 0 {

            entity.Player.weaponCooldown = 8

            let bullet = Entity(
                position: entity.position + (facingVector * 4),
                velocity: facingVector * 100,
                direction: entity.direction,
                kind: .bullet(ticks: 0)
            )
            gameState.entities.append(bullet)
        }
        if IsKeyDown(KeyR) {
            entity.position = .zero
        }

        if entity.Player.weaponCooldown > 0 {
            entity.Player.weaponCooldown -= 1
        }

    case .bullet:
        if entity.BulletTicks > 100 {
            entity.flags.insert(.dead)
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

    case .bullet:
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
