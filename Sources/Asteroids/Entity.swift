
import muse

struct Entity {

    var id: Int
    var position: V2
    var velocity: V2
    var direction: f32

    var kind: Kind

    enum Kind {
        case player(isFiring: Bool, isAccelerating: Bool)
        case exhaust(ticks: Int)
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

    var Player: (isFiring: Bool, isAccelerating: Bool) {
        get {
            guard case .player(let tuple) = kind else {
                fatalError()
            }
            return tuple
        }
        set {
            self.kind = .player(isFiring: newValue.isFiring, isAccelerating: newValue.isAccelerating)
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
}

// TODO(vdka): we need the game state here too.
func update(_ entity: inout Entity, _ gameState: inout GameState) {

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


            var exhaust = Entity(
                position: -entity.position.normalized() * 3,
                velocity: -entity.velocity.normalized() * entity.velocity.length,
                direction: entity.direction,
                kind: .exhaust(ticks: 0)
            )
            gameState.add(&exhaust)
        } else {
            entity.Player.isAccelerating = false
        }
        if IsKeyDown(KeyS) {

        }
        if IsKeyDown(KeySpace) {
            entity.Player.isFiring = true
        }

    case .exhaust:
        if entity.ExhaustTicks > 1 {
            gameState.remove(&entity)
        } else {
            entity.ExhaustTicks += 1
        }
    }
}

func draw(_ entity: Entity) {

    switch entity.kind {
    case .player:
        var t1 = V2(x: entity.position.x, y: entity.position.y + 3)
        var t2 = V2(x: entity.position.x - 2, y: entity.position.y - 4)
        var t3 = V2(x: entity.position.x + 2, y: entity.position.y - 4)

        t1 = t1.rotated(by: entity.direction, around: entity.position)
        t2 = t2.rotated(by: entity.direction, around: entity.position)
        t3 = t3.rotated(by: entity.direction, around: entity.position)

        FillTri(t1, t2, t3, .white)

    case .exhaust:
        var t1 = V2(x: entity.position.x, y: entity.position.y - 7.5)
        var t2 = V2(x: entity.position.x - 1, y: entity.position.y - 4)
        var t3 = V2(x: entity.position.x + 1, y: entity.position.y - 4)

        t1 = t1.rotated(by: entity.direction, around: entity.position)
        t2 = t2.rotated(by: entity.direction, around: entity.position)
        t3 = t3.rotated(by: entity.direction, around: entity.position)

        FillTri(t1, t2, t3, .red)
    }
}
