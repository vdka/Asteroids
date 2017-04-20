
import muse

func draw(_ entity: Entity) {

    switch entity.kind {
    case EntityKindPlayer:
        var t1 = V2(x: entity.position.x, y: entity.position.y + 3)
        var t2 = V2(x: entity.position.x - 2, y: entity.position.y - 4)
        var t3 = V2(x: entity.position.x + 2, y: entity.position.y - 4)

        t1 = rotate(t1, about: entity.position, by: entity.direction)
        t2 = rotate(t2, about: entity.position, by: entity.direction)
        t3 = rotate(t3, about: entity.position, by: entity.direction)

        FillTri(t1, t2, t3, .white)

    case EntityKindExhaust:
        var t1 = V2(x: entity.position.x, y: entity.position.y - 7.5)
        var t2 = V2(x: entity.position.x - 1, y: entity.position.y - 4)
        var t3 = V2(x: entity.position.x + 1, y: entity.position.y - 4)

        t1 = rotate(t1, about: entity.position, by: entity.direction)
        t2 = rotate(t2, about: entity.position, by: entity.direction)
        t3 = rotate(t3, about: entity.position, by: entity.direction)

        FillTri(t1, t2, t3, .red)

    default:
        fatalError()
    }
}

func update(_ entity: Entity) {
    
}

func rotate(_ point: V2, about center: V2, by angle: Float) -> V2 {
    var p = point

    let s = sin(angle)
    let c = cos(angle)

    // translate point back to origin:
    p.x -= center.x
    p.y -= center.y

    // rotate point
    let xnew = p.x * c - p.y * s
    let ynew = p.x * s + p.y * c

    // translate point back:
    p.x = xnew + center.x
    p.y = ynew + center.y
    return p;
}
