
#ifndef MUSE_H
#define MUSE_H

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <stddef.h>
#include <stdarg.h>
#include <assert.h>
#include <string.h>
#include <time.h>
#include <math.h>

typedef int8_t   i8;
typedef uint8_t  u8;
typedef int16_t  i16;
typedef uint16_t u16;
typedef int32_t  i32;
typedef uint32_t u32;
typedef int64_t  i64;
typedef uint64_t u64;

typedef u32 uint;

typedef float  f32;
typedef double f64;

#if !defined(__cplusplus)
    #if (defined(_MSC_VER) && _MSC_VER <= 1800) || (!defined(_MSC_VER) && !defined(__STDC_VERSION__))
        #ifndef true
        #define true  (0 == 0)
        #endif
        #ifndef false
        #define false (0 != 0)
        #endif
    #else
        #include <stdbool.h>
    #endif
#endif

typedef bool b8;
typedef size_t    usize;
typedef ptrdiff_t isize;

#if !defined(__cplusplus)
    #if !defined(__STDC_VERSION__)
    #define inline __inline__
    #else
    #define inline
    #endif
#endif

#ifndef __cplusplus
// Boolean type
    #ifndef __APPLE__
        #if !defined(_STDBOOL_H)
            typedef enum { false, true } bool;
            #define _STDBOOL_H
        #endif
    #else
        #include <stdbool.h>
    #endif
#endif

//----------------------------------------------------------------------------------
// Some basic Defines
//----------------------------------------------------------------------------------

#ifndef TAU
    #define TAU 6.28318530717958647692528676655900576f
#endif

#ifndef PI
    #define PI 3.14159265358979323846f
#endif

#define DEG2RAD (TAU/360.0f)
#define RAD2DEG (360.0f/TAU)
#define BIT_CHECK(a,b) ((a) & (1<<(b)))

typedef enum {
    UNCOMPRESSED_GRAYSCALE = 1,     // 8 bit per pixel (no alpha)
    UNCOMPRESSED_GRAY_ALPHA,        // 16 bpp (2 channels)
    UNCOMPRESSED_R5G6B5,            // 16 bpp
    UNCOMPRESSED_R8G8B8,            // 24 bpp
    UNCOMPRESSED_R5G5B5A1,          // 16 bpp (1 bit alpha)
    UNCOMPRESSED_R4G4B4A4,          // 16 bpp (4 bit alpha)
    UNCOMPRESSED_R8G8B8A8,          // 32 bpp
} TextureFormat;

// Vector2 type
typedef struct V2 {
    f32 x;
    f32 y;
} V2;

// While td2d focuses on everything in 2d the renderer still is 3 dimentional.
typedef union V3 {
    struct { f32 x, y, z; };
    V2  xy;
    f32 e[3];
} V3;

// Color type, RGBA (32bit)
typedef union Color {
    struct { u8 r, g, b, a; };
    u32 rgba;
    u8  e[4];
} Color;

// Quaternion type
typedef struct Quaternion {
    f32 x, y, z, w;
} Quaternion;

typedef struct Camera {
    f32 x, y, width, height;
} Camera;

// Some Basic Colors
#define LIGHTGRAY  (Color){ 200, 200, 200, 255 }   // Light Gray
#define GRAY       (Color){ 130, 130, 130, 255 }   // Gray
#define DARKGRAY   (Color){ 80, 80, 80, 255 }      // Dark Gray
#define YELLOW     (Color){ 253, 249, 0, 255 }     // Yellow
#define GOLD       (Color){ 255, 203, 0, 255 }     // Gold
#define ORANGE     (Color){ 255, 161, 0, 255 }     // Orange
#define PINK       (Color){ 255, 109, 194, 255 }   // Pink
#define RED        (Color){ 230, 41, 55, 255 }     // Red
#define MAROON     (Color){ 190, 33, 55, 255 }     // Maroon
#define GREEN      (Color){ 0, 228, 48, 255 }      // Green
#define LIME       (Color){ 0, 158, 47, 255 }      // Lime
#define DARKGREEN  (Color){ 0, 117, 44, 255 }      // Dark Green
#define SKYBLUE    (Color){ 102, 191, 255, 255 }   // Sky Blue
#define BLUE       (Color){ 0, 121, 241, 255 }     // Blue
#define DARKBLUE   (Color){ 0, 82, 172, 255 }      // Dark Blue
#define PURPLE     (Color){ 200, 122, 255, 255 }   // Purple
#define VIOLET     (Color){ 135, 60, 190, 255 }    // Violet
#define DARKPURPLE (Color){ 112, 31, 126, 255 }    // Dark Purple
#define BEIGE      (Color){ 211, 176, 131, 255 }   // Beige
#define BROWN      (Color){ 127, 106, 79, 255 }    // Brown
#define DARKBROWN  (Color){ 76, 63, 47, 255 }      // Dark Brown

#define WHITE      (Color){ 255, 255, 255, 255 }   // White
#define BLACK      (Color){ 0, 0, 0, 255 }         // Black
#define BLANK      (Color){ 0, 0, 0, 0 }           // Blank (Transparent)
#define MAGENTA    (Color){ 255, 0, 255, 255 }     // Magenta
#define RAYWHITE   (Color){ 245, 245, 245, 255 }   // My own White (raylib logo)

typedef enum Key Key;
enum Key {
    KeyUnknown =          -1,
    KeySpace =            32,
    KeyApostrophe =       39,  /* ' */
    KeyComma =            44,  /* , */
    KeyMinus =            45,  /* - */
    KeyPeriod =           46,  /* . */
    KeySlash =            47,  /* / */
    Key0 =                48,
    Key1 =                49,
    Key2 =                50,
    Key3 =                51,
    Key4 =                52,
    Key5 =                53,
    Key6 =                54,
    Key7 =                55,
    Key8 =                56,
    Key9 =                57,
    KeySemicolon =        59,  /* ; */
    KeyEqual =            61,  /* = */
    KeyA =                65,
    KeyB =                66,
    KeyC =                67,
    KeyD =                68,
    KeyE =                69,
    KeyF =                70,
    KeyG =                71,
    KeyH =                72,
    KeyI =                73,
    KeyJ =                74,
    KeyK =                75,
    KeyL =                76,
    KeyM =                77,
    KeyN =                78,
    KeyO =                79,
    KeyP =                80,
    KeyQ =                81,
    KeyR =                82,
    KeyS =                83,
    KeyT =                84,
    KeyU =                85,
    KeyV =                86,
    KeyW =                87,
    KeyX =                88,
    KeyY =                89,
    KeyZ =                90,
    KeyLeftBracket =      91,  /* [ */
    KeyBackslash =        92,  /* \ */
    KeyRightbracket =     93,  /* ] */
    KeyGraveAccent =      96,  /* ` */
    KeyWorld1 =           161, /* non-US #1 */
    KeyWorld2 =           162, /* non-US #2 */
    KeyEscape =           256,
    KeyEnter =            257,
    KeyTab =              258,
    KeyBackspace =        259,
    KeyInsert =           260,
    KeyDelete =           261,
    KeyRight =            262,
    KeyLeft =             263,
    KeyDown =             264,
    KeyUp =               265,
    KeyPageUp =           266,
    KeyPageDown =         267,
    KeyHome =             268,
    KeyEnd =              269,
    KeyCapsLock =         280,
    KeyScrollLock =       281,
    KeyNumLock =          282,
    KeyPrintScreen =      283,
    KeyPause =            284,
    KeyF1 =               290,
    KeyF2 =               291,
    KeyF3 =               292,
    KeyF4 =               293,
    KeyF5 =               294,
    KeyF6 =               295,
    KeyF7 =               296,
    KeyF8 =               297,
    KeyF9 =               298,
    KeyF10 =              299,
    KeyF11 =              300,
    KeyF12 =              301,
    KeyF13 =              302,
    KeyF14 =              303,
    KeyF15 =              304,
    KeyF16 =              305,
    KeyF17 =              306,
    KeyF18 =              307,
    KeyF19 =              308,
    KeyF20 =              309,
    KeyF21 =              310,
    KeyF22 =              311,
    KeyF23 =              312,
    KeyF24 =              313,
    KeyF25 =              314,
    KeyKp0 =              320,
    KeyKp1 =              321,
    KeyKp2 =              322,
    KeyKp3 =              323,
    KeyKp4 =              324,
    KeyKp5 =              325,
    KeyKp6 =              326,
    KeyKp7 =              327,
    KeyKp8 =              328,
    KeyKp9 =              329,
    KeyKpDecimal =        330,
    KeyKpDivide =         331,
    KeyKpMultiply =       332,
    KeyKpSubtract =       333,
    KeyKpAdd =            334,
    KeyKpEnter =          335,
    KeyKpEqual =          336,
    KeyLeftShift =        340,
    KeyLeftControl =      341,
    KeyLeftAlt =          342,
    KeyLeftSuper =        343,
    KeyRightShift =       344,
    KeyRightControl =     345,
    KeyRightAlt =         346,
    KeyRightSuper =       347,
    KeyMenu =             348,
    KeyLast =             KeyMenu
};

typedef enum MouseButton MouseButton;
enum MouseButton {
    MouseButton1 = 0,
    MouseButton2 = 1,
    MouseButton3 = 2,
    MouseButton4 = 3,
    MouseButton5 = 4,
    MouseButton6 = 5,
    MouseButton7 = 6,
    MouseButton8 = 7,
    MouseButtonLeft   = MouseButton1,
    MouseButtonRight  = MouseButton2,
    MouseButtonMiddle = MouseButton3,
};


/**API*****************************/
/*                                */
/*       ###    ########  ####    */
/*      ## ##   ##     ##  ##     */
/*     ##   ##  ##     ##  ##     */
/*    ##     ## ########   ##     */
/*    ######### ##         ##     */
/*    ##     ## ##         ##     */
/*    ##     ## ##        ####    */
/*                                */
/**********************************/
#define API extern

#ifdef __cplusplus
extern "C" {            // Prevents name mangling of functions
#endif

f64 frameTime;

API void InitWindow(i32 width, i32 height, const char* title);     // Initialize Window and OpenGL Graphics
API void CloseWindow(void);                                        // Close Window and Terminate Context
API b8   WindowShouldClose(void);                                  // Detect if KEY_ESCAPE pressed or Close icon pressed
API b8   IsWindowMinimized(void);                                  // Detect if window is minimized (or lost focus)
API V2   GetWindowDimentions(void);                                // Returns the current dimentions of the window
API void ToggleFullscreen(void);                                   // Fullscreen toggle
API void SetCamera(Camera camera);
API V2   WorldToCamera(V2 point);


API b8   IsMouseButtonPressed(MouseButton button);                         // Detect if a mouse button has been pressed once
API b8   IsMouseButtonDown(MouseButton button);                            // Detect if a mouse button is being pressed
API b8   IsMouseButtonReleased(MouseButton button);                        // Detect if a mouse button has been released once
API b8   IsMouseButtonUp(MouseButton button);                              // Detect if a mouse button is NOT being pressed
API i32  GetMouseX(void);                                          // Returns mouse position X
API i32  GetMouseY(void);                                          // Returns mouse position Y
API V2   GetMousePosition(void);                                   // Returns the current mouse position
API void SetMousePosition(V2 position);                            // Set mouse position XY
API i32  GetMouseWheelMove(void);                                  // Returns mouse wheel movement Y


API b8   IsKeyPressed(Key key);                                    // Detect if a key has been pressed once
API b8   IsKeyDown(Key key);                                       // Detect if a key is being pressed
API b8   IsKeyReleased(Key key);                                   // Detect if a key has been released once
API b8   IsKeyUp(Key key);                                         // Detect if a key is NOT being pressed
API Key  GetKeyPressed(void);                                      // Get latest key pressed
API void SetExitKey(Key key);                                      // Set a custom key to exit program (default is ESC)

API void ClearBackground(Color color);                             // Sets Background Color
API void BeginFrame(void);                                         // Setup drawing canvas to start drawing
API void EndFrame(void);                                           // End canvas drawing and Swap Buffers (Double Buffers)
API f64  GetTime(void);                                            // Returns the time since InitTimer() was cal

API u32  TextureLoad(const char* fileName);                        // Loads a texture from a file and returns a handle

API void SetLineWidth(f32 width);                                  // Set the width of the lines drawn

API void DrawPoint(f32 x, f32 y, Color color);                     // Draw a single 'point'

API void DrawLine(f32 x1, f32 y1, f32 x2, f32 y2, Color color);    // Draw a line between 2 points
API void DrawTri(V2 v1, V2 v2, V2 v3, Color color);                // Draw a Triangle outline
API void FillTri(V2 v1, V2 v2, V2 v3, Color color);                // Fill a Triangle
API void FillPoly(V2 center, i32 sides, f32 radius, Color color);
API void FillCircle(V2 center, f32 radius, Color color);

API void DrawQuadCentered(V2 center, V2 size, Color color);
API void FillQuadCentered(V2 center, V2 size, Color color);

API void DrawTriXY(f32 x1, f32 y1, f32 x2, f32 y2, f32 x3, f32 y3, Color color);                    // Draw a Triangle outline
API void FillTriXY(f32 x1, f32 y1, f32 x2, f32 y2, f32 x3, f32 y3, Color color);                    // Fill a Triangle
API void DrawQuadXY(f32 x1, f32 y1, f32 x2, f32 y2, f32 x3, f32 y3, f32 x4, f32 y4, Color color);   // Draw a Rectangle outline
API void FillQuadXY(f32 x1, f32 y1, f32 x2, f32 y2, f32 x3, f32 y3, f32 x4, f32 y4, Color color);   // Fill a Rectangle

API void DrawTexture(u32 id, V2 center, V2 size);
API void DrawTextureClip(u32 id, V2 destCenter, V2 destSize, V2 srcCenter,  V2 srcSize);

#ifdef __cplusplus
} // extern "C"
#endif

/**INTERNAL*****************************************************************/
/*                                                                         */
/*  #### ##    ## ######## ######## ########  ##    ##    ###    ##        */
/*   ##  ###   ##    ##    ##       ##     ## ###   ##   ## ##   ##        */
/*   ##  ####  ##    ##    ##       ##     ## ####  ##  ##   ##  ##        */
/*   ##  ## ## ##    ##    ######   ########  ## ## ## ##     ## ##        */
/*   ##  ##  ####    ##    ##       ##   ##   ##  #### ######### ##        */
/*   ##  ##   ###    ##    ##       ##    ##  ##   ### ##     ## ##        */
/*  #### ##    ##    ##    ######## ##     ## ##    ## ##     ## ########  */
/*                                                                         */
/***************************************************************************/

#if defined(MUSE_IMPLEMENTATION) && !defined(MUSE_IMPLEMENTATION_DONE)
#define MUSE_IMPLEMENTATION_DONE

// Include GLEW first; It's magic
#include "glad.h"

// Include GLFW
#undef GLFW_INCLUDE_GLCOREARB
#include <GLFW/glfw3.h>

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

/**GLOBALS********************************************************/
/*                                                               */
/*    ######   ##        #######  ########     ###    ##         */
/*   ##    ##  ##       ##     ## ##     ##   ## ##   ##         */
/*   ##        ##       ##     ## ##     ##  ##   ##  ##         */
/*   ##   #### ##       ##     ## ########  ##     ## ##         */
/*   ##    ##  ##       ##     ## ##     ## ######### ##         */
/*   ##    ##  ##       ##     ## ##     ## ##     ## ##         */
/*    ######   ########  #######  ########  ##     ## ########   */
/*                                                               */
/*****************************************************************/

//-----------------------------------------------------------------
// Stuff
//-----------------------------------------------------------------

u8 configFlags;

GLFWwindow* window;

i32 screenWidth, screenHeight;
i32 displayWidth, displayHeight;
i32 renderWidth, renderHeight;

// Register Mouse States
i8 previousMouseState[GLFW_MOUSE_BUTTON_LAST] = { 0 };
i8 currentMouseState[GLFW_MOUSE_BUTTON_LAST]  = { 0 };
i32 previousMouseWheelY = 0;
i32 currentMouseWheelY  = 0;

// Register Keyboard States
i8 previousKeyState[GLFW_KEY_LAST] = { 0 };
i8 currentKeyState[GLFW_KEY_LAST]  = { 0 };

i32 lastKeyPressed = -1;

V2 mousePosition;

f64 currentTime, previousTime;    // Used to track timmings
f64 updateTime, drawTime;         // Time measures for update and draw
f64 frameTime;                    // Time measure for one frame
f64 targetTime = 0.0;             // Desired time for one frame, if 0 not applied

i32 exitKey = GLFW_KEY_ESCAPE;

//-----------------------------------------------------------------
// OpenGL STUFF
//-----------------------------------------------------------------

typedef struct Shader {
    u32 id;        // Shader program id

    // Vertex attributes locations (default locations)
    i32 positionLoc;
    i32 texcoordLoc;
    i32 colorLoc;
    i32 textureLoc;

    i32 cameraLoc;
} Shader;

#define ATLAS_SIZE 64
typedef struct Atlas {
    u32   id;           // the OpenGL Texture id
    u32   width;        // the total width of the atlas texture
    u32   height;       // the total height of the atlas texture
    u32   mipmaps;      // the number of mipmaps
    u32   curX;         // the x coord that represents the position to put the start of the next texture
    u32   curY;         // the y coord that represents the position to put the start of the next texture
    u32   maxY;         // the larget (heightwise) object in the current row
    u32   count;        // the number of textures stored in the atlas
    f32*  texcoords;    // an array of texturePositions
    Color pixels[];
} Atlas;

// typically (GL_POINTS | GL_LINES | GL_LINE_LOOP | GL_TRIANGLES | GL_TRIANGLE_STRIP)
// Buffers used for storing vertices from Draw & Fill calls before unloading to GPU
typedef struct RenderBuffer {
    i32 max : 30;           // max number of vertices stored in the Buffer
    b8  isQuad : 1;         // to use indices or not to use indices
    b8  isTextured : 1;     // is this to be textured?
    i32 count;              // number of vertices in the buffer

    i32 storedPerShape;     // number of vertices stored per shape
    i32 renderedPerShape;   // number of vertices rendered per shape

    V2*    vertices;        // vertex position
    Color* colors;          // vertex colors (RGBA - 5 components per vertex)
    V2*    texcoords;

    i32 mode;               // The draw mode to use for OpenGL
    u32 vao;                // OpenGL Vertex Array Object
    u32 vbo[3];             // OpenGL Vertex Buffer Object (1 for color, 1 for positions, 1 for texcoords)
} RenderBuffer;

u32 quadIndicesVBO;
u32 whiteTexture;

#define VBO_POSITION  0
#define VBO_COLOR     1
#define VBO_TEXCOORD  2

RenderBuffer pixels;                // Default dynamic buffer for pixel data
RenderBuffer lines;                 // Default dynamic buffer for lines data
RenderBuffer connectedLines;        // Default dynamic buffer for connnected lines data
RenderBuffer triangles;             // Default dynamic buffer for triangles data
RenderBuffer quads;                 // Default dynamic buffer for quads data (used to draw textures)
RenderBuffer texturedQuads;         // Default buffer for drawing textured quads from

Atlas* currentAtlas;
Shader currentShader;
RenderBuffer* currentRenderBuffer;
Color currentColor;
Camera currentCamera;

f32 minLineWidth;
f32 maxLineWidth;

/**SHADERS*******************************************************************/
/*                                                                          */
/*     ######  ##     ##    ###    ########  ######## ########   ######     */
/*    ##    ## ##     ##   ## ##   ##     ## ##       ##     ## ##    ##    */
/*    ##       ##     ##  ##   ##  ##     ## ##       ##     ## ##          */
/*     ######  ######### ##     ## ##     ## ######   ########   ######     */
/*          ## ##     ## ######### ##     ## ##       ##   ##         ##    */
/*    ##    ## ##     ## ##     ## ##     ## ##       ##    ##  ##    ##    */
/*     ######  ##     ## ##     ## ########  ######## ##     ##  ######     */
/*                                                                          */
/****************************************************************************/

#define GLSL(src) "#version 400 core\n" #src

const char* vertexShaderSource = GLSL(
    in vec2 vPosition;
    in vec2 vTexcoord;
    in vec4 vColor;
    out vec2 fTexcoord;
    out vec4 fColor;

    uniform vec4 camera;

    void main() {
        fTexcoord = vTexcoord;
        fColor = vColor;

        vec2 camPos = vec2(-camera.x + vPosition.x, -camera.y + vPosition.y);
        vec2 renPos = vec2(camPos.x * 2 / camera.z, camPos.y * 2 / camera.w);
        gl_Position = vec4(renPos, 0.0, 1.0);
    }
);

const char* fragmentShaderSource = GLSL(
    in vec2 fTexcoord;
    in vec4 fColor;
    out vec4 outputColor;

    uniform sampler2D tex;

    void main() {
        vec4 texelColor = texture(tex, fTexcoord);
        outputColor = texelColor * fColor;
        // finalColor = fragColor;
    }
);

/**UTILITIES*********************************************************************/
/*                                                                              */
/*    ##     ## ######## #### ##       #### ######## #### ########  ######      */
/*    ##     ##    ##     ##  ##        ##     ##     ##  ##       ##    ##     */
/*    ##     ##    ##     ##  ##        ##     ##     ##  ##       ##           */
/*    ##     ##    ##     ##  ##        ##     ##     ##  ######    ######      */
/*    ##     ##    ##     ##  ##        ##     ##     ##  ##             ##     */
/*    ##     ##    ##     ##  ##        ##     ##     ##  ##       ##    ##     */
/*     #######     ##    #### ######## ####    ##    #### ########  ######      */
/*                                                                              */
/********************************************************************************/

typedef enum { VERBOSE, INFO, WARNING, ERROR } LogLevel;
static void Log(LogLevel msgType, const char *text, ...) {
#ifdef MINLOGLEVEL
    if (msgType < MINLOGLEVEL) return;
#endif

    va_list args;

    switch(msgType) {
        case VERBOSE: fprintf(stdout, "VERBOSE: "); break;
        case INFO: fprintf(stdout, "INFO: "); break;
        case WARNING: fprintf(stdout, "WARNING: "); break;
        case ERROR: fprintf(stdout, "ERROR: "); break;
    }

    va_start(args, text);
    vfprintf(stdout, text, args);
    va_end(args);

    fprintf(stdout, "\n");

    fflush(stdout);
    // exit on ERROR
    if (msgType == ERROR) exit(1);
}

static Atlas* AtlasCreate() {

    Atlas* atlas = (Atlas*) malloc((sizeof *atlas) + ATLAS_SIZE * ATLAS_SIZE * sizeof(Color));
    memset(atlas->pixels, 0, ATLAS_SIZE * ATLAS_SIZE * sizeof(Color));
    atlas->id = 0;
    atlas->mipmaps = 1;
    atlas->width = ATLAS_SIZE;
    atlas->height = ATLAS_SIZE;
    atlas->curX = 0;
    atlas->curY = ATLAS_SIZE;
    atlas->maxY = 0;

    atlas->count = 0;
    atlas->texcoords = malloc(4 * (sizeof *atlas->texcoords)); // 4 texcoords, 2 for each corner

    glGenTextures(1, &atlas->id);

    // This is the only place where we bind a texture ever.
    glActiveTexture(GL_TEXTURE0 + atlas->id);
    glBindTexture(GL_TEXTURE_2D, atlas->id);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, atlas->width, atlas->height, 0, GL_RGBA, GL_UNSIGNED_BYTE, atlas->pixels);
    glUniform1i(currentShader.textureLoc, atlas->id);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);       // Set texture to repeat on x-axis
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);       // Set texture to repeat on y-axis

    // Magnification and minification filters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);  // Alternative: GL_LINEAR
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);  // Alternative: GL_LINEAR

    return atlas;
}

static const char* GetExtension(const char *filename) {
    const char *dot = strrchr(filename, '.');
    if(!dot || dot == filename) return "";
    return dot + 1;
}

static u32 AtlasLoadTexture(const char* fileName) {

    // NOTE: Do I need to check or will stbi_load fail gracefully?
    if (!(strcmp(GetExtension(fileName), "png") == 0) ||
        (strcmp(GetExtension(fileName), "bmp") == 0) ||
        (strcmp(GetExtension(fileName), "tga") == 0) ||
        (strcmp(GetExtension(fileName), "jpg") == 0))
    {
        return 0;
    }

    i32 width = 0;
    i32 height = 0;
    i32 bytesPerPixel = 0;
    i32 format = 0;

    // NOTE: Using stb_image to load images (Supports: BMP, TGA, PNG, JPG)
    u8* data = stbi_load(fileName, &width, &height, &bytesPerPixel, 0);

    if (bytesPerPixel == 1) format = UNCOMPRESSED_GRAYSCALE;
    else if (bytesPerPixel == 2) format = UNCOMPRESSED_GRAY_ALPHA;
    else if (bytesPerPixel == 3) format = UNCOMPRESSED_R8G8B8;
    else if (bytesPerPixel == 4) format = UNCOMPRESSED_R8G8B8A8;
    assert(format == UNCOMPRESSED_R8G8B8A8); // only one supported currently

    currentAtlas->texcoords = realloc(currentAtlas->texcoords, (currentAtlas->count + 1) * 4 * (sizeof *currentAtlas->texcoords));

    if (currentAtlas->curX + width >= currentAtlas->width) {
        currentAtlas->curX = 0;
        currentAtlas->curY -= currentAtlas->maxY;
        currentAtlas->maxY = 0;
    }

    for (u32 y = 0; y < height; y++) {

        u32 srcIndex = (y * 4) * width;
        u32 dstIndex = (currentAtlas->curY * ATLAS_SIZE) - ATLAS_SIZE + currentAtlas->curX - y * currentAtlas->width;

        assert(dstIndex != 0);

        memcpy(&currentAtlas->pixels[dstIndex], &data[srcIndex], sizeof(Color) * width);
    }

    currentAtlas->texcoords[currentAtlas->count * 4]     = (f32) currentAtlas->curX / (f32) ATLAS_SIZE;
    currentAtlas->texcoords[currentAtlas->count * 4 + 3] = (f32) (currentAtlas->curY - height) / (f32) ATLAS_SIZE;
    currentAtlas->texcoords[currentAtlas->count * 4 + 2] = (f32) (currentAtlas->curX + width) / (f32) ATLAS_SIZE;
    currentAtlas->texcoords[currentAtlas->count * 4 + 1] = (f32) currentAtlas->curY / (f32) ATLAS_SIZE;

    currentAtlas->curX += width;
    currentAtlas->maxY = currentAtlas->maxY > height ? currentAtlas->maxY : height;

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, currentAtlas->width, currentAtlas->height, 0, GL_RGBA, GL_UNSIGNED_BYTE, currentAtlas->pixels);

    free(data);

    return currentAtlas->count++;
}

static V2 WindowToWorld(V2 point) {
    V2 windowSize = GetWindowDimentions();
    f64 vertScale = currentCamera.width / windowSize.x;
    f64 horzScale = currentCamera.height / windowSize.y;

    V2 windowCenter = {windowSize.x / 2, windowSize.y / 2};
    V2 dWorldCenter = {point.x - windowCenter.x, point.y - windowCenter.y};


    V2 result = {dWorldCenter.x * horzScale, -dWorldCenter.y * vertScale};

    return result;
}

// Initializes hi-resolution timer
static void InitTimer(void) {
    srand((u32) time(NULL));

    previousTime = GetTime(); // seed our timer.
}

static b8  GetKeyStatus(i32 key) {
    return glfwGetKey(window, key);
}

// Get one mouse button state
static b8  GetMouseButtonStatus(i32 button) {
    return glfwGetMouseButton(window, button);
}

// Poll (store) all input events
static void PollInputEvents(void) {

    // Reset last key pressed registered
    lastKeyPressed = -1;

    // Mouse input polling
    f64 mouseX;
    f64 mouseY;

    glfwGetCursorPos(window, &mouseX, &mouseY);

    mousePosition.x = (f32) mouseX;
    mousePosition.y = (f32) mouseY;

    // Keyboard input polling (automatically managed by GLFW3 through callback)

    // Register previous keys states
    for (int i = 0; i < GLFW_KEY_LAST; i++) previousKeyState[i] = currentKeyState[i];

    // Register previous mouse states
    for (int i = 0; i < GLFW_MOUSE_BUTTON_LAST; i++) previousMouseState[i] = currentMouseState[i];

    previousMouseWheelY = currentMouseWheelY;
    currentMouseWheelY = 0;
}

static void ErrorCallback(int error, const char *description) {
    Log(WARNING, "[GLFW3 Error] Code: %i Decription: %s", error, description);
}

static void KeyCallback(GLFWwindow *window, i32 key, i32 scancode, i32 action, i32 mods) {
    // TODO(vdka): Support for reading on that mods bitfield
    if (key == exitKey && action == GLFW_PRESS) {
        glfwSetWindowShouldClose(window, GL_TRUE);
    } else {
        currentKeyState[key] = action;
        if (action == GLFW_PRESS) lastKeyPressed = key;
    }
}

static void MouseButtonCallback(GLFWwindow *window, i32 button, i32 action, i32 mods) {
    // TODO(vdka): Support for reading on that mods bitfield
    currentMouseState[button] = action;
}

static void ScrollCallback(GLFWwindow *window, f64 xoffset, f64 yoffset) {
    currentMouseWheelY = (i32) yoffset;
}

static u32 LoadShader(u32 type, const char* source) {

    u32 shader = glCreateShader(type);
    glShaderSource(shader, 1, &source, NULL);
    glCompileShader(shader);

    // check for compile errors
    i32 params = -1;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &params);
    if (params != GL_TRUE) {
        i32 msgLen = 0;
        i32 maxLen = 2048;
        char msg[maxLen];
        glGetShaderInfoLog(shader , maxLen, &msgLen, msg);

        if (type == GL_VERTEX_SHADER)
            Log(WARNING, "Error compiling vertex shader! %s", msg);
        else if (type == GL_FRAGMENT_SHADER)
            Log(WARNING, "Error compiling fragment shader! %s", msg);
        else
            Log(WARNING, "Error compiling shader of unknown kind! %s", msg);
    }

    return shader;
}

static u32 CreateShaderProgram(u32 vert, u32 frag) {

    u32 program = glCreateProgram();

    if (vert) glAttachShader(program, vert);
    if (frag) glAttachShader(program, frag);

    glLinkProgram(program);

    // check if link was successful
    int params = -1;
    glGetProgramiv(program, GL_LINK_STATUS, &params);
    if (GL_TRUE != params) {

        i32 msgLen = 0;
        i32 maxLen = 2048;
        char msg[maxLen];
        glGetProgramInfoLog(program, maxLen, &msgLen, msg);
        Log(WARNING, "Error linking shader! %s", msg);
    }
    return program;
}

static RenderBuffer BufferCreate(i32 stored, i32 rendered, i32 mode, i32 maxVerts, b8  isQuad, b8  isTextured) {
    RenderBuffer buffer = {0};
    buffer.max = maxVerts;
    buffer.storedPerShape = stored;
    buffer.renderedPerShape = rendered;
    buffer.count = 0;

    buffer.mode = mode;

    buffer.isQuad     = isQuad;
    buffer.isTextured = isTextured;

    buffer.vertices = (V2*) malloc((sizeof *buffer.vertices) * maxVerts);
    buffer.texcoords = (V2*) malloc((sizeof *buffer.texcoords) * maxVerts);
    buffer.colors   = (Color*) malloc((sizeof *buffer.colors) * maxVerts);

    for (u32 i = 0; i < ATLAS_SIZE; i++)
        buffer.texcoords[i] = i % 2 == 0 ?
            (V2){0, 0} :
            (V2){1.f / ATLAS_SIZE, 1.f / ATLAS_SIZE};

    glGenVertexArrays(1, &buffer.vao);
    glBindVertexArray(buffer.vao);

    glGenBuffers(1, &buffer.vbo[VBO_POSITION]);
    glBindBuffer(GL_ARRAY_BUFFER, buffer.vbo[VBO_POSITION]);
    glBufferData(GL_ARRAY_BUFFER, (sizeof *buffer.vertices) * maxVerts, buffer.vertices, GL_DYNAMIC_DRAW);
    glEnableVertexAttribArray(currentShader.positionLoc);
    glVertexAttribPointer(currentShader.positionLoc, 2, GL_FLOAT, false, 0, NULL);

    glGenBuffers(1, &buffer.vbo[VBO_COLOR]);
    glBindBuffer(GL_ARRAY_BUFFER, buffer.vbo[VBO_COLOR]);
    glBufferData(GL_ARRAY_BUFFER, (sizeof *buffer.colors) * maxVerts, buffer.colors, GL_DYNAMIC_DRAW);
    glEnableVertexAttribArray(currentShader.colorLoc);
    glVertexAttribPointer(currentShader.colorLoc, 4, GL_UNSIGNED_BYTE, GL_TRUE, 0, NULL);

    if (isTextured) {
        glGenBuffers(1, &buffer.vbo[VBO_TEXCOORD]);
        glBindBuffer(GL_ARRAY_BUFFER, buffer.vbo[VBO_TEXCOORD]);
        glBufferData(GL_ARRAY_BUFFER, (sizeof *buffer.texcoords) * maxVerts, buffer.texcoords, GL_DYNAMIC_DRAW);
        glVertexAttribPointer(currentShader.texcoordLoc, 2, GL_FLOAT, false, 0, NULL);
        glEnableVertexAttribArray(currentShader.texcoordLoc);
    }

    // unbind the vertex array
    glBindVertexArray(0);
    return buffer;
}

static void BufferDefaultsCreate() {

    // TODO(vdka): Allow macro's to define the buffer sizes

    pixels         = BufferCreate(1, 1, GL_POINT,     2048,     false, false);
    lines          = BufferCreate(2, 2, GL_LINES,     4096,     false, false);
    connectedLines = BufferCreate(2, 2, GL_LINE_LOOP, 4096,     false, false);
    triangles      = BufferCreate(3, 3, GL_TRIANGLES, 2048 * 3, false, false);
    quads          = BufferCreate(4, 6, GL_TRIANGLES, 2048 * 4, true,  false);
    texturedQuads  = BufferCreate(4, 6, GL_TRIANGLES, 2048 * 4, true,  true);

    u32* indices = (u32*) malloc(sizeof(u32) * 1024 * 6);
    for (int i = 0, k = 0; i < 1024 * 6; i += 6, k++) {
        indices[i]     = 4 * k;
        indices[i + 1] = 4 * k + 1;
        indices[i + 2] = 4 * k + 2;
        indices[i + 3] = 4 * k;
        indices[i + 4] = 4 * k + 2;
        indices[i + 5] = 4 * k + 3;
    }

    glGenBuffers(1, &quadIndicesVBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, quadIndicesVBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, (sizeof *indices) * 1024 * 6, indices, GL_STATIC_DRAW);

    free(indices); // we can free these from CPU now they are on the GPU
}

// Update default internal buffers (VBOs) with vertex array data
// NOTE: If there is not vertex data, buffers doesn't need to be updated (vertexCount > 0)
// TODO: If no data changed on the CPU arrays --> No need to re-update GPU arrays (change flag required)
static void BufferUpdate(RenderBuffer* buffer) {

    // Update lines vertex buffers
    if (buffer->count > 0) {
        glBindVertexArray(buffer->vao);

        // vertex positions buffer
        glBindBuffer(GL_ARRAY_BUFFER, buffer->vbo[VBO_POSITION]);
        glBufferSubData(GL_ARRAY_BUFFER, 0, (sizeof *buffer->vertices) * buffer->count, buffer->vertices);

        // colors buffer
        glBindBuffer(GL_ARRAY_BUFFER, buffer->vbo[VBO_COLOR]);
        glBufferSubData(GL_ARRAY_BUFFER, 0, (sizeof *buffer->colors) * buffer->count, buffer->colors);

        // texcoords buffer
        if (buffer->isTextured) {
            glBindBuffer(GL_ARRAY_BUFFER, buffer->vbo[VBO_TEXCOORD]);
            glBufferSubData(GL_ARRAY_BUFFER, 0, (sizeof *buffer->texcoords) * buffer->count, buffer->texcoords);
        }

        // Unbind the current VAO
        glBindVertexArray(0);
    }
}

static void BufferUpdateDefaults() {
    BufferUpdate(&pixels);
    BufferUpdate(&lines);
    BufferUpdate(&connectedLines);
    BufferUpdate(&triangles);
    BufferUpdate(&quads);
    BufferUpdate(&texturedQuads);
}

static void BufferDraw(RenderBuffer* buffer) {

    if (buffer->count > 0) {

        glBindVertexArray(buffer->vao);

        if (buffer->isTextured) {
            glBindTexture(GL_TEXTURE_2D, currentAtlas->id);
        } else {
            glBindTexture(GL_TEXTURE_2D, whiteTexture);
        }

        if (buffer->isQuad) {
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, quadIndicesVBO);
            glDrawElements(buffer->mode, buffer->renderedPerShape * buffer->count / buffer->storedPerShape, GL_UNSIGNED_INT, 0);
        } else {
            glDrawArrays(buffer->mode, 0, buffer->count);
        }

        // reset buffer count
        buffer->count = 0;

        // unbind
        glBindVertexArray(0);
    }
}

static void BufferDrawDefaults() {
    BufferDraw(&pixels);
    BufferDraw(&lines);
    BufferDraw(&connectedLines);
    BufferDraw(&triangles);
    BufferDraw(&quads);
    BufferDraw(&texturedQuads);
}

static void InitGraphicsDevice(i32 width, i32 height, const char* title) {

    screenWidth = width;
    screenHeight = height;

    glfwSetErrorCallback(ErrorCallback);

    if (!glfwInit()) Log(ERROR, "Failed to initialize GLFW");

    glfwDefaultWindowHints();

    // VERSION
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 1);
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, true);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    // MISC HINTS
    glfwWindowHint(GLFW_RESIZABLE, false);
    glfwWindowHint(GLFW_SAMPLES, 4);


    GLFWmonitor* monitor = glfwGetPrimaryMonitor();
    const GLFWvidmode *mode = glfwGetVideoMode(monitor);

    displayWidth = mode->width;
    displayHeight = mode->height;

    if (screenWidth <= 0) screenWidth = displayWidth;
    if (screenHeight <= 0) screenHeight = displayHeight;

    window = glfwCreateWindow(width, height, title, NULL, NULL);

    if (window == NULL) {
        glfwTerminate();
        Log(ERROR, "Failed to open GLFW window. If you have an Intel GPU they are not compatible with OpenGL 3.3");
    } else {
        Log(INFO, "Display device initialized successfully");
        Log(INFO, "Display size: %i x %i", displayWidth, displayHeight);
        Log(INFO, "Render size: %i x %i", renderWidth, renderHeight);
        Log(INFO, "Screen size: %i x %i", screenWidth, screenHeight);
    }

    // Set our current OpenGL Context to that of the windows
    glfwMakeContextCurrent(window);

    gladLoadGLLoader((GLADloadproc) glfwGetProcAddress);
    gladLoadGL();
    if(!gladLoadGL()) Log(ERROR, "Failed to initialize GLAD");

#ifdef __APPLE__
    // Get framebuffer size of current window. Required to handle HiDPI display correctly.
    i32 fbWidth, fbHeight;
    glfwGetFramebufferSize(window, &fbWidth, &fbHeight);

    glViewport(0, 0, fbWidth, fbHeight);
#else
    glViewport(0, 0, renderWidth, renderHeight);
#endif

    // TODO(vdka): Set window callbacks

    glfwSetKeyCallback(window, KeyCallback);
    glfwSetMouseButtonCallback(window, MouseButtonCallback);
    glfwSetScrollCallback(window, ScrollCallback);
    // glfwSetCursorPosCallback(window, CursorPosCallback);

    // Disable VSync by default
    glfwSwapInterval(0);

    // setup culling
    // glEnable(GL_CULL_FACE);
    // glCullFace(GL_BACK);
    // glFrontFace(GL_CW);

    // TODO(vdka): enable VSYNC?

    f32 lineWidthRange[2];
    glGetFloatv(GL_ALIASED_LINE_WIDTH_RANGE, lineWidthRange);
    minLineWidth = lineWidthRange[0];
    maxLineWidth = lineWidthRange[1];

    // Platform details

    Log(INFO, "GPU: Vendor:   %s", glGetString(GL_VENDOR));
    Log(INFO, "GPU: Renderer: %s", glGetString(GL_RENDERER));
    Log(INFO, "GPU: Version:  %s", glGetString(GL_VERSION));
    Log(INFO, "GPU: GLSL:     %s", glGetString(GL_SHADING_LANGUAGE_VERSION));

    u32 vertexShader   = LoadShader(GL_VERTEX_SHADER, vertexShaderSource);
    u32 fragmentShader = LoadShader(GL_FRAGMENT_SHADER, fragmentShaderSource);
    // u32 geometryShader = LoadShader(GL_GEOMETRY_SHADER, geometryShaderSource);

    currentShader.id = CreateShaderProgram(vertexShader, fragmentShader);
    glUseProgram(currentShader.id);

    currentShader.positionLoc = glGetAttribLocation(currentShader.id, "vPosition");
    currentShader.texcoordLoc = glGetAttribLocation(currentShader.id, "vTexcoord");
    currentShader.colorLoc    = glGetAttribLocation(currentShader.id, "vColor");

    currentShader.textureLoc  = glGetUniformLocation(currentShader.id, "tex");
    currentShader.cameraLoc   = glGetUniformLocation(currentShader.id, "camera");

    BufferDefaultsCreate();

    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    u32 pixel = 0xFFFFFFFF;
    glGenTextures(1, &whiteTexture);
    glBindTexture(GL_TEXTURE_2D, whiteTexture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 1, 1, 0, GL_RGBA, GL_UNSIGNED_BYTE, &pixel);

    currentAtlas = AtlasCreate();

    if (currentAtlas->id == 0) Log(WARNING, "Atlas initialization failed");
    else Log(INFO, "[TEX ID %i] Atlas texture loaded successfully", currentAtlas->id);

    ClearBackground(WHITE);
}

// Bumps the call count on the buffer
static void setBuffer(RenderBuffer* buffer) {
    currentRenderBuffer = buffer;
}

static void vertex(f32 x, f32 y) {
    if (currentRenderBuffer == NULL) Log(ERROR, "Attempt to draw vertex without an active buffer");
    assert(currentRenderBuffer->count < currentRenderBuffer->max); // TODO(vdka): Render the buffer if it's full.

    currentRenderBuffer->vertices[currentRenderBuffer->count] = (V2){x, y};
    currentRenderBuffer->colors[currentRenderBuffer->count] = currentColor;
    currentRenderBuffer->count += 1;
}

// NOTE: Ensure this is called after calling vertex else the count will not be correct and bad memory access may occur
static void texcoord(f32 x, f32 y) {
    if (currentRenderBuffer == NULL) Log(ERROR, "Attempt to set texcoord without an active buffer");
    assert(currentRenderBuffer->count != 0);

    currentRenderBuffer->texcoords[currentRenderBuffer->count - 1] = (V2){x, y};
}

// TODO(vdka): Determine a prefix
static void setColor(Color color) {

    currentColor = color;
}

static i32 GetNumCircleSegments(f32 radius) {
    f32 cameraArea = currentCamera.width * currentCamera.height;
    f32 circleArea = TAU * (radius * radius) / 2;

    // TODO(vdka): tweak!
    i32 sides = 360 * sqrtf(circleArea) / sqrtf(cameraArea);

    if (sides < 16) return 16;
    if (sides > 90) return 90;
    return sides;
}

/**IMPLEMENTATION******************************************************************************************************************/
/*                                                                                                                                */
/*   #### ##     ## ########  ##       ######## ##     ## ######## ##    ## ########    ###    ######## ####  #######  ##    ##   */
/*    ##  ###   ### ##     ## ##       ##       ###   ### ##       ###   ##    ##      ## ##      ##     ##  ##     ## ###   ##   */
/*    ##  #### #### ##     ## ##       ##       #### #### ##       ####  ##    ##     ##   ##     ##     ##  ##     ## ####  ##   */
/*    ##  ## ### ## ########  ##       ######   ## ### ## ######   ## ## ##    ##    ##     ##    ##     ##  ##     ## ## ## ##   */
/*    ##  ##     ## ##        ##       ##       ##     ## ##       ##  ####    ##    #########    ##     ##  ##     ## ##  ####   */
/*    ##  ##     ## ##        ##       ##       ##     ## ##       ##   ###    ##    ##     ##    ##     ##  ##     ## ##   ###   */
/*   #### ##     ## ##        ######## ######## ##     ## ######## ##    ##    ##    ##     ##    ##    ####  #######  ##    ##   */
/*                                                                                                                                */
/**********************************************************************************************************************************/

#define DEF inline

DEF void InitWindow(i32 width, i32 height, const char* title) {
    Log(INFO, "Initializing ...");

    // Init graphics device (display device and OpenGL context)
    InitGraphicsDevice(width, height, title);

    glfwSetInputMode(window, GLFW_STICKY_KEYS, true);
}

DEF void CloseWindow(void) {
    glfwDestroyWindow(window);
    glfwTerminate();
}

DEF b8  WindowShouldClose(void) {
    PollInputEvents();
    return glfwWindowShouldClose(window) || glfwGetKey(window, exitKey) == GLFW_PRESS;
}

API b8  IsWindowMinimized(void);

DEF V2 GetWindowDimentions(void) {
    i32 w, h;
    glfwGetWindowSize(window, &w, &h);

    return (V2){w, h};
}

API void ToggleFullscreen(void);

DEF void SetCamera(Camera camera) {

    currentCamera = camera;
    glUniform4f(currentShader.cameraLoc, camera.x, camera.y, camera.width, camera.height);
}

DEF V2 WorldToCamera(V2 point) {
    V2 result = {currentCamera.x + point.x, currentCamera.y + point.y};
    return result;
}

DEF b8  IsMouseButtonPressed(MouseButton button) {
    if ((currentMouseState[button] != previousMouseState[button]) && (currentMouseState[button] == 1)) return true;
    else return false;
}

DEF b8  IsMouseButtonDown(MouseButton button) {
    if (GetMouseButtonStatus(button) == 1) return true;
    else return false;
}

DEF b8  IsMouseButtonReleased(MouseButton button) {
    if ((currentMouseState[button] != previousMouseState[button]) && (currentMouseState[button] == 0)) return true;
    else return false;
}

DEF b8  IsMouseButtonUp(MouseButton button) {
    if (GetMouseButtonStatus(button) == 0) return true;
    else return false;
}

DEF V2 GetMousePosition(void) {

    return WindowToWorld(mousePosition);
}

DEF void SetMousePosition(V2 position) {
    mousePosition = position;
    glfwSetCursorPos(window, position.x, position.y);
}

DEF i32 GetMouseWheelMove(void) {
    return previousMouseWheelY;
}

DEF b8  IsKeyPressed(i32 key) {
    if ((currentKeyState[key] != previousKeyState[key]) && (currentKeyState[key] == 1))
        return true;
    else
        return false;
}

// Detect if a key is being pressed (key held down)
DEF b8  IsKeyDown(i32 key) {
    if (GetKeyStatus(key) == 1) return true;
    else return false;
}

// Detect if a key has been released once
DEF b8  IsKeyReleased(i32 key) {
    b8  released = false;

    if ((currentKeyState[key] != previousKeyState[key]) && (currentKeyState[key] == 0)) released = true;
    else released = false;

    return released;
}

// Detect if a key is NOT being pressed (key not held down)
DEF b8  IsKeyUp(i32 key) {
    if (GetKeyStatus(key) == 0) return true;
    else return false;
}

// Get the last key pressed
DEF i32 GetKeyPressed(void) {
    return lastKeyPressed;
}

// Set a custom key to exit program
// NOTE: default exitKey is ESCAPE
DEF void SetExitKey(i32 key) {
    exitKey = key;
}

DEF void ClearBackground(Color color) {
    glClearColor(color.r, color.g, color.b, color.a);
}

DEF void BeginFrame(void) {
    currentTime = GetTime();
    updateTime = currentTime - previousTime;
    previousTime = currentTime;

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

DEF void EndFrame(void) {
    BufferUpdateDefaults();
    BufferDrawDefaults();

    glfwSwapBuffers(window);
    glfwPollEvents();

    // Frame time constrol system
    currentTime = GetTime();
    drawTime = currentTime - previousTime;
    previousTime = currentTime;

    frameTime = updateTime + drawTime;

    f64 extraTime = 0.0;

    while (frameTime < targetTime) {
        currentTime = GetTime();
        extraTime = currentTime - previousTime;
        previousTime = currentTime;
        frameTime += extraTime;
    }
}

DEF f64 GetTime(void) {
    return glfwGetTime();
}

DEF u32 TextureLoad(const char* fileName) {
    return AtlasLoadTexture(fileName);
}

DEF void SetLineWidth(f32 width) {

    if (minLineWidth > width || maxLineWidth < width) {
        // TODO(vdka): Don't let this stop us, use geometry!
        static b8  warned = false;
        if (!warned) {
            warned = true;
            Log(WARNING, "Attempt to set line width to %f outside of supported line width range of %f - %f",
                width, minLineWidth, maxLineWidth);
        }
        return;
    }

    // Render out lines with the current width
    BufferUpdate(&lines);
    BufferUpdate(&connectedLines);
    BufferDraw(&lines);
    BufferDraw(&connectedLines);

    glLineWidth(width);
}

DEF void DrawPoint(f32 x, f32 y, Color color) {
    setBuffer(&pixels);
    setColor(color);
    {
        vertex(x, y);
    }
    setBuffer(NULL);
}

DEF void DrawLine(f32 x1, f32 y1, f32 x2, f32 y2, Color color) {
    setBuffer(&lines);
    setColor(color);
    {
        vertex(x1, y1);
        vertex(x2, y2);
    }
    setBuffer(NULL);
}

DEF void DrawTri(V2 v1, V2 v2, V2 v3, Color color) {
    setBuffer(&connectedLines);
    setColor(color);
    {
        vertex(v1.x, v1.y);
        vertex(v2.x, v2.y);
        vertex(v3.x, v3.y);
    }
    setBuffer(NULL);
    BufferUpdate(&connectedLines);
    BufferDraw(&connectedLines);
}

DEF void FillTri(V2 v1, V2 v2, V2 v3, Color color) {
    setBuffer(&triangles);
    setColor(color);
    {
        vertex(v1.x, v1.y);
        vertex(v2.x, v2.y);
        vertex(v3.x, v3.y);
    }
    setBuffer(NULL);
}

DEF void DrawTriXY(f32 x1, f32 y1, f32 x2, f32 y2, f32 x3, f32 y3, Color color) {
    setBuffer(&connectedLines);
    setColor(color);
    {
        vertex(x1, y1);
        vertex(x2, y2);
        vertex(x3, y3);
    }
    setBuffer(NULL);
    BufferUpdate(&connectedLines);
    BufferDraw(&connectedLines);
}

DEF void FillTriXY(f32 x1, f32 y1, f32 x2, f32 y2, f32 x3, f32 y3, Color color) {
    setBuffer(&triangles);
    setColor(color);
    {
        vertex(x1, y1);
        vertex(x2, y2);
        vertex(x3, y3);
    }
    setBuffer(NULL);
}

DEF void FillPoly(V2 center, i32 sides, f32 radius, Color color) {
    if (sides < 3) sides = 3;

    setBuffer(&triangles);
    setColor(color);
    {
        f32 theta = 2 * 3.1415926 / (f32) sides;
        f32 c = cosf(theta);
        f32 s = sinf(theta);
        f32 t;

        //we start at angle = 0
        f32 x = radius;
        f32 y = 0;

        for(int ii = 0; ii < sides; ii++) {
            vertex(x + center.x, y + center.y);

            //apply the rotation matrix
            t = x;
            x = c * x - s * y;
            y = s * t + c * y;

            vertex(x + center.x, y + center.y);
            vertex(center.x, center.y);
        }
    }
    setBuffer(&triangles);
}

DEF void FillCircle(V2 center, f32 radius, Color color) {
    f32 sides = GetNumCircleSegments(radius);
    FillPoly(center, sides, radius, color);
}

DEF void DrawQuadXY(f32 x1, f32 y1, f32 x2, f32 y2, f32 x3, f32 y3, f32 x4, f32 y4, Color color) {
    setBuffer(&connectedLines);
    setColor(color);
    {
        vertex(x1, y1);
        vertex(x2, y2);
        vertex(x3, y3);
        vertex(x4, y4);
        vertex(x1, y1);
    }
    setBuffer(NULL);
    BufferUpdate(&connectedLines);
    BufferDraw(&connectedLines);
}

DEF void FillQuadXY(f32 x1, f32 y1, f32 x2, f32 y2, f32 x3, f32 y3, f32 x4, f32 y4, Color color) {
    setBuffer(&quads);
    setColor(color);
    {
        vertex(x1, y1);
        vertex(x2, y2);
        vertex(x3, y3);
        vertex(x4, y4);
    }
    setBuffer(NULL);
}

DEF void DrawQuadCentered(V2 center, V2 size, Color color) {
    f32 halfWidth   = size.x / 2;
    f32 halfHeight  = size.y / 2;

    setBuffer(&connectedLines);
    setColor(color);
    {
        vertex(center.x + halfWidth, center.y - halfHeight); // tr
        vertex(center.x - halfWidth, center.y - halfHeight); // tl
        vertex(center.x - halfWidth, center.y + halfHeight); // bl
        vertex(center.x + halfWidth, center.y + halfHeight); // br
        vertex(center.x + halfWidth, center.y - halfHeight); // tr
    }
    setBuffer(NULL);
    BufferUpdate(&connectedLines);
    BufferDraw(&connectedLines);
}

DEF void FillQuadCentered(V2 center, V2 size, Color color) {
    f32 halfWidth   = size.x / 2;
    f32 halfHeight  = size.y / 2;

    setBuffer(&quads);
    setColor(color);
    {
        vertex(center.x - halfWidth, center.y + halfHeight); // tl
        vertex(center.x - halfWidth, center.y - halfHeight); // bl
        vertex(center.x + halfWidth, center.y - halfHeight); // br
        vertex(center.x + halfWidth, center.y + halfHeight); // tr
    }
    setBuffer(NULL);
}

DEF void DrawTexture(u32 id, V2 center, V2 size) {
    f32 halfWidth   = size.x / 2;
    f32 halfHeight  = size.y / 2;
    f32* coords = &currentAtlas->texcoords[id * 4];
    V2 textureTopLeft = {coords[0], coords[1]};
    V2 textureBottomRight = {coords[2], coords[3]};
    setColor(WHITE);
    setBuffer(&texturedQuads);
    {
        vertex(center.x - halfWidth, center.y + halfHeight); // tl
        texcoord(textureTopLeft.x, textureTopLeft.y);

        vertex(center.x - halfWidth, center.y - halfHeight); // bl
        texcoord(textureTopLeft.x, textureBottomRight.y);

        vertex(center.x + halfWidth, center.y - halfHeight); // br
        texcoord(textureBottomRight.x, textureBottomRight.y);

        vertex(center.x + halfWidth, center.y + halfHeight); // tr
        texcoord(textureBottomRight.x, textureTopLeft.y);
    }
    setBuffer(NULL);
}

DEF void DrawTextureClip(u32 id, V2 destCenter, V2 destSize, V2 srcCenter,  V2 srcSize) {
    f32 halfDestWidth   = destSize.x / 2;
    f32 halfDestHeight  = destSize.y / 2;
    f32* coords = &currentAtlas->texcoords[id * 4];
    V2 textureTopLeft = {coords[0], coords[1]};

    setColor(WHITE);
    setBuffer(&texturedQuads);
    {
        vertex(destCenter.x - halfDestWidth, destCenter.y + halfDestHeight); // tl
        texcoord(textureTopLeft.x + srcCenter.x / ATLAS_SIZE, textureTopLeft.y - srcCenter.y / ATLAS_SIZE);

        vertex(destCenter.x - halfDestWidth, destCenter.y - halfDestHeight); // bl
        texcoord(textureTopLeft.x + srcCenter.x / ATLAS_SIZE, textureTopLeft.y - (srcCenter.y + srcSize.y) / ATLAS_SIZE);

        vertex(destCenter.x + halfDestWidth, destCenter.y - halfDestHeight); // br
        texcoord(textureTopLeft.x + (srcCenter.x + srcSize.x) / ATLAS_SIZE, textureTopLeft.y - (srcCenter.y + srcSize.y) / ATLAS_SIZE);

        vertex(destCenter.x + halfDestWidth, destCenter.y + halfDestHeight); // tr
        texcoord(textureTopLeft.x + (srcCenter.x + srcSize.x) / ATLAS_SIZE, textureTopLeft.y - srcCenter.y / ATLAS_SIZE);
    }
    setBuffer(NULL);
}

#endif // defined(MUSE_IMPLEMENTATION) && !defined(MUSE_IMPLEMENTATION_DONE)
#endif // MUSE_H
