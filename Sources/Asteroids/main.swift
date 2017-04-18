
import muse

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

    var collision = V2()
    collision.x = rayDelta.x * near
    collision.y = rayDelta.y * near

    collision.x += rayStart.x
    collision.y += rayStart.y

    return collision
}

extension Color: ExpressibleByIntegerLiteral {

    public init(integerLiteral value: UInt32) {
        self = unsafeBitCast(value.bigEndian, to: Color.self)
    }

    public init(rgba: UInt32) {
        self.rgba = rgba.bigEndian
    }

    static var white: Color = 0xffffffff
    static var black: Color = 0x000000ff
    static var green: Color = 0x00ff00ff
    static var blue:  Color = 0x0000ffff
}

extension V2 {
    static let zero = V2(x: 0, y: 0)
}

InitWindow(640, 480, "Asteroids")

var cam = Camera(x: 0, y: 0, width: 3.2, height: 2.4)

SetCamera(cam)

// TODO(vdka): Relative to current file
let filepath = "/" + #file.characters.split(separator: "/").dropLast(3).map(String.init).joined(separator: "/") + "/data/player-sheet.png"

var sprite = TextureLoad(filepath)

while !WindowShouldClose() {

    if IsKeyDown(KeyD) { cam.x += 1 * Float(frameTime) }
    if IsKeyDown(KeyA) { cam.x -= 1 * Float(frameTime) }
    if IsKeyDown(KeyW) { cam.y += 1 * Float(frameTime) }
    if IsKeyDown(KeyS) { cam.y -= 1 * Float(frameTime) }

    SetCamera(cam)

    let mouse = WorldToCamera(GetMousePosition())

    if IsMouseButtonDown(MouseButtonLeft) {
        print(mouse)
    }
    // TODO(vdka): Zoom

    let endRay = raycast(from: V2.zero, to: mouse, V2(x: 0.5, y: 0.5), seg2: V2(x: 0.5, y: 1))

    BeginFrame()
    ClearBackground(.white)

//    FillTriXY(0, 0, 0, 0.5, 0.25, 0.25, 0xff0000ff)
//    FillTriXY(0, 0, 0.25, 0.25, 0.5, 0, 0x00ff00ff)
//    FillTriXY(0.5, 0, 0.5, 0.5, 0, 0.5, 0x0000ffff)

    FillQuadCentered(V2(x: 0.5, y: 0.75), V2(x: 0.05, y: 0.5), .black)
    DrawLine(0, 0, endRay.x, endRay.y, 0xff0000ff)

//    FillQuadCentered(V2(x: -0.5, y: 0.75), V2(x: 0.1, y: 0.5), .black)
//    DrawLine(0.5, 0.5, 0.5, 1.1, .black)


    DrawTexture(sprite, V2(x: 1, y: 0.6), V2(x: 0.36, y: 0.06))
    DrawTextureClip(sprite, V2(x: -1, y: 0.6), V2(x: 0.06, y: 0.06), V2(x: 0, y: 0), V2(x: 6, y: 6))

    FillCircle(mouse, 0.05, 0xffaf00ff)

    EndFrame()
}

CloseWindow()


//    while (!WindowShouldClose()) {
//
//        SetCamera(cam);
//
//        V2 mouse = WorldToCamera(GetMousePosition());
//
//        if (previousMouseWheelY) {
//            cam.width += (f32) previousMouseWheelY / 10 * cam.width * frameTime;
//            cam.height += (f32) previousMouseWheelY / 10 * cam.height * frameTime;
//            SetCamera(cam);
//        }
//
//        V2 endRay = raycast((V2){.0f, .0f}, mouse, (V2){.5f, .5f}, (V2){.5f, 1.f});
//
//        BeginFrame();
//        {
//            ClearBackground(WHITE);
//            FillTriXY(.0, .0, .0, .5, .25, .25, RED);
//            FillTriXY(.0, .0, .25, .25, .5, .0, GREEN);
//            FillTriXY(.5, .0, .5, .5, .0, .5, BLUE);
//
//            DrawLine(0, 0, endRay.x, endRay.y, RED);
//
//            FillQuadCentered((V2){-.5, -.5}, (V2){.25, .25}, RED);
//            FillQuadCentered((V2){ 0, -.5}, (V2){.25, .25}, GREEN);
//            FillQuadCentered((V2){.5, -.5}, (V2){.25, .25}, BLUE);
//
//            FillCircle(mouse, .05, ORANGE);
//
//            DrawTexture(sprite, (V2){1.f, .6f}, (V2){.36, .06});
//            DrawTextureClip(sprite, (V2){-1.f, .6f}, (V2){.06f, .06f}, (V2){0, 0}, (V2){6, 6});
//            // FillRect((Rect){mouse.x, mouse.y, .5, .5}, (Color){fabs(mouse.x) * 80, fabs(mouse.y) * 100, 0, 1});
//        }
//        EndFrame();
//    }
//    return 0;
//}
