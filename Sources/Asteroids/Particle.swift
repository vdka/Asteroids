
import muse

struct Particle {

    var position: V2
    var velocity: V2
    var color: Color
    var remainingTicks: UInt32
}

func update(_ particle: inout Particle, _ gameState: inout GameState) {

    let worldLeftBound  = gameState.camera.x - gameState.camera.width  / 2
    let worldRightBound = gameState.camera.x + gameState.camera.width  / 2
    let worldUpperBound = gameState.camera.x + gameState.camera.height / 2
    let worldLowerBound = gameState.camera.x - gameState.camera.height / 2

    particle.position.x = wrap(particle.position.x, lower: worldLeftBound, upper: worldRightBound)
    particle.position.y = wrap(particle.position.y, lower: worldLowerBound, upper: worldUpperBound)

    particle.position += particle.velocity * f32(GetFrameTime())

    let v = UInt8(clamp(f32(1) - f32(1) / f32(particle.remainingTicks), lower: 0, upper: 1) * 200)
    particle.color.a = v

    if particle.remainingTicks > 0 {
        particle.remainingTicks -= 1
    }

    let fps =

    let decay = 1 - (0.9999 * f32(GetFrameTime()))
    print(decay)
    particle.velocity *= decay
}

func draw(_ particle: Particle) {

    FillCircle(particle.position, 0.3, particle.color)
}

