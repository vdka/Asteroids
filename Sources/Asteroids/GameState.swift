
import muse

struct GameState {
    var currStateSize: Int
    var camera: Camera
    var museState: OpaquePointer

    var rng = PCGRand32()

    var entities: [Entity] = []
    var particles: [Particle] = []

    init(camera: Camera) {
        self.currStateSize = MemoryLayout<GameState>.size
        self.camera = camera
        self.museState = GetState()
    }
}
