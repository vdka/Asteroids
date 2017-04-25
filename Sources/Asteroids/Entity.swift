
import muse

struct Entity {

    var position: V2
    var velocity: V2
    var direction: f32

    var flags: Flag
    var kind: Kind

    enum Kind {
        case player(timeToRespawn: Int, weaponCooldown: Int, isAccelerating: Bool)
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

    var Player: (timeToRespawn: Int, weaponCooldown: Int, isAccelerating: Bool) {
        get {
            guard case .player(let tuple) = kind else {
                fatalError()
            }
            return tuple
        }
        set {
            self.kind = .player(timeToRespawn: newValue.timeToRespawn, weaponCooldown: newValue.weaponCooldown, isAccelerating: newValue.isAccelerating)
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

    var isBullet: Bool {

        guard case .bullet = kind else {
            return false
        }
        return true
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

        if IsKeyDown(KeyR) {
            entity.position = .zero
        }
        if IsKeyDown(KeyD) {

            entity.direction -= 6 * f32(GetFrameTime())
            entity.direction = wrap(entity.direction, lower: 0, upper: TAU)
        }
        if IsKeyDown(KeyA) {

            entity.direction += 6 * f32(GetFrameTime())
            entity.direction = wrap(entity.direction, lower: 0, upper: TAU)
        }
        if IsKeyDown(KeyW) {

            func emitParticles(excess: Bool = false) {
                let numberOfExhaustParticlesToEmit = gameState.rng.boundedNext(excess ? 100 : 30) as UInt32 + 3

                let exhaustTarget = (entity.position + (-facingVector * 15))

                for _ in 0..<numberOfExhaustParticlesToEmit {

                    let xOffset: Float = gameState.rng.boundedNext(shipAngle) - shipAngle / 2
                    let position = (entity.position + (-facingVector * 3))
                        .rotated(by: xOffset, around: entity.position)

                    let deviation: f32 = excess ? TAU * 0.075 : 0.025
                    let exhaustVector = -(position - exhaustTarget)
                        .normalized()
                        .rotated(by: gameState.rng.boundedNext(deviation * TAU) - (deviation * TAU) / 2) * 30

                    // use this to shift more red in the closer to the center something is.
                    let r = gameState.rng.boundedNext(0.2) + 0.9
                    let g = gameState.rng.boundedNext(0.4)
                    let b = gameState.rng.boundedNext(0.1)

                    let color = Color(r: r, g: g, b: b)

                    let exhaustParticle = Particle(
                        position: position,
                        velocity: exhaustVector * (excess ? 1.5 : 1),
                        color: color,
                        remainingTicks: gameState.rng.boundedNext(30)
                    )
                    gameState.newParticles.append(exhaustParticle)
                }

                // Odd math makes acceleration against inertia quicker to make the game feel more responsive.
                let deltaDir = (V2.up.rotated(by: entity.direction) - entity.velocity.normalized()).length / 2
                let deltaVel = V2.up.rotated(by: entity.direction) * (deltaDir + 0.2) * 50

                if deltaDir > gameState.rng.boundedNext(0.4) + 0.8 && gameState.rng.boundedNext(1.0) < 0.25 {
                    emitParticles(excess: true)
                }

                if !excess {
                    entity.velocity += deltaVel * f32(GetFrameTime())
                }
            }

            if entity.Player.isAccelerating, gameState.rng.boundedNext(1.0) < 0.99 {
                emitParticles()
            } else {
                emitParticles(excess: true)
            }
            entity.Player.isAccelerating = true


        } else {
            entity.Player.isAccelerating = false
        }
        if IsKeyDown(KeyS) {
            entity.velocity *= 0.99 * (1 - f32(GetFrameTime()))
        }
        if IsKeyDown(KeySpace), entity.Player.weaponCooldown == 0 {

            entity.Player.weaponCooldown = 12

            let bullet = Entity(
                position: entity.position + (facingVector * 4),
                velocity: facingVector * 100 + entity.velocity,
                direction: entity.direction,
                kind: .bullet(ticks: 0)
            )
            gameState.newEntities.append(bullet)
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

    case .asteroid(_, let points):

        // TODO(vdka): Sim the movement and check the bullet end position instead
        let closestBullet = gameState.entities.enumerated()
            .filter({ $0.element.isBullet })
            .sorted(by: { [entity] in (entity.position - $0.0.element.position).length < (entity.position - $0.1.element.position).length })
            .first

        let (bulletIndex, bullet) = (closestBullet?.offset, closestBullet?.element)

        let player = gameState.entities[0]

        var prevPoint = entity.position + points.last!
        for point in points {
            let point = entity.position + point

            if let bullet = bullet, let bulletIndex = bulletIndex, intersect(prevPoint, point, bullet.position, bullet.position + bullet.velocity * f32(GetFrameTime())) != nil {
                entity.flags.insert(.dead)

                gameState.entities[bulletIndex].flags.insert(.dead)
            } else if let collisionDirection = intersect(prevPoint, point, player.position, player.position + player.velocity * f32(GetFrameTime())) {

                gameState.entities[0].flags.insert(.dead)

                let numberOfParticlesToEmit = gameState.rng.boundedNext(400) as UInt32 + 200

                let emitterDirection = -collisionDirection.normalized()

                for _ in 0..<numberOfParticlesToEmit {

                    let emissionVector = emitterDirection
                        .rotated(by: gameState.rng.boundedNext(TAU * 0.75) - TAU / 2)

                    // use this to shift more red in the closer to the center something is.
                    let r = gameState.rng.boundedNext(0.2) + 0.9
                    let g = gameState.rng.boundedNext(0.4)
                    let b = gameState.rng.boundedNext(0.1)

                    let color = Color(r: r, g: g, b: b)

                    let particle = Particle(
                        position: player.position,
                        velocity: emissionVector * (gameState.rng.boundedNext(10) as Float + 20),
                        color: color,
                        remainingTicks: gameState.rng.boundedNext(50)
                    )
                    gameState.newParticles.append(particle)
                }
            }

            prevPoint = point
        }
    }
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
