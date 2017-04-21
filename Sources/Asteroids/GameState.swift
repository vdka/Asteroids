
import muse

struct GameState {
    var currStateSize: Int
    var camera: Camera
    var museState: OpaquePointer

    var rng = PCGRand32()
    var nextEntityId: Int = 1
    var entities: [Int: Entity] = [:]
//    var entities = Arena<Entity>(capacity: 50)

    init(camera: Camera) {
        self.currStateSize = MemoryLayout<GameState>.size
        self.camera = camera
        self.museState = GetState()
    }
}

extension GameState {

    mutating func add(_ entity: inout Entity) {
        defer {
            nextEntityId = nextEntityId &+ 1
            if nextEntityId == 0 {
                nextEntityId += 1
            }
        }

        entity.id = nextEntityId

        entities[nextEntityId] = entity
    }

    mutating func update(_ entity: Entity) {
        guard entity.id != 0 else {
            return
        }

        entities[entity.id] = entity
    }

    mutating func remove(_ entity: inout Entity) {
        entities[entity.id] = nil
        entity.id = 0
    }
}
