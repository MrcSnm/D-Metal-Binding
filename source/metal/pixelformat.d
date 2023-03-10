module metal.pixelformat;
import objc.runtime;

enum MTLPixelFormat : NSUInteger
{
    ///Ordinary format with one 8-bit normalized unsigned integer component.
    A8Unorm = 1,
    ///Ordinary format with one 8-bit normalized unsigned integer component.
    R8Unorm = 10,
    ///Ordinary format with one 8-bit normalized unsigned integer component with conversion between sRGB and linear space.
    R8Unorm_sRGB = 11,
    ///Ordinary format with one 8-bit normalized signed integer component.
    R8Snorm = 12,
    ///Ordinary format with one 8-bit unsigned integer component.
    R8Uint = 13,
    ///Ordinary format with one 8-bit signed integer component.
    R8Sint = 14,
    ///Ordinary format with one 16-bit normalized unsigned integer component.
    R16Unorm = 20,
    ///Ordinary format with one 16-bit normalized signed integer component.
    R16Snorm = 22,
    ///Ordinary format with one 16-bit unsigned integer component.
    R16Uint = 23,
    ///Ordinary format with one 16-bit signed integer component.
    R16Sint = 24,
    ///Ordinary format with one 16-bit floating-point component.
    R16Float = 25,
    ///Ordinary format with two 8-bit normalized unsigned integer components.
    RG8Unorm = 30,
    ///Ordinary format with two 8-bit normalized unsigned integer components with conversion between sRGB and linear space.
    RG8Unorm_sRGB = 31,
    ///Ordinary format with two 8-bit normalized signed integer components.
    RG8Snorm = 32,
    ///Ordinary format with two 8-bit unsigned integer components.
    RG8Uint = 33,
    ///Ordinary format with two 8-bit signed integer components.
    RG8Sint = 34,
    ///Packed 16-bit format with normalized unsigned integer color components: 5 bits for blue, 6 bits for green, 5 bits for red, packed into 16 bits.
    B5G6R5Unorm = 40,
    ///Packed 16-bit format with normalized unsigned integer color components: 5 bits each for BGR and 1 for alpha, packed into 16 bits.
    A1BGR5Unorm = 41,
    ///Packed 16-bit format with normalized unsigned integer color components: 4 bits each for ABGR, packed into 16 bits.
    ABGR4Unorm = 42,
    ///Packed 16-bit format with normalized unsigned integer color components: 5 bits each for BGR and 1 for alpha, packed into 16 bits.
    BGR5A1Unorm = 43,
    ///Ordinary format with one 32-bit unsigned integer component.
    R32Uint = 53,
    ///Ordinary format with one 32-bit signed integer component.
    R32Sint = 54,
    ///Ordinary format with one 32-bit floating-point component.
    R32Float = 55,
    ///Ordinary format with two 16-bit normalized unsigned integer components.
    RG16Unorm = 60,
    ///Ordinary format with two 16-bit normalized signed integer components.
    RG16Snorm = 62,
    ///Ordinary format with two 16-bit unsigned integer components.
    RG16Uint = 63,
    ///Ordinary format with two 16-bit signed integer components.
    RG16Sint = 64,
    ///Ordinary format with two 16-bit floating-point components.
    RG16Float = 65,
    ///Ordinary format with four 8-bit normalized unsigned integer components in RGBA order.
    RGBA8Unorm = 70,
    ///Ordinary format with four 8-bit normalized unsigned integer components in RGBA order with conversion between sRGB and linear space.
    RGBA8Unorm_sRGB = 71,
    ///Ordinary format with four 8-bit normalized signed integer components in RGBA order.
    RGBA8Snorm = 72,
    ///Ordinary format with four 8-bit unsigned integer components in RGBA order.
    RGBA8Uint = 73,
    ///Ordinary format with four 8-bit signed integer components in RGBA order.
    RGBA8Sint = 74,
    ///Ordinary format with four 8-bit normalized unsigned integer components in BGRA order.
    BGRA8Unorm = 80,
    ///Ordinary format with four 8-bit normalized unsigned integer components in BGRA order with conversion between sRGB and linear space.
    BGRA8Unorm_sRGB = 81,
    ///A 32-bit packed pixel format with four normalized unsigned integer components: 10-bit blue, 10-bit green, 10-bit red, and 2-bit alpha.
    BGR10A2Unorm = 94,
    ///A 32-bit packed pixel format with four normalized unsigned integer components: 10-bit red, 10-bit green, 10-bit blue, and 2-bit alpha.
    RGB10A2Unorm = 90,
    ///A 32-bit packed pixel format with four unsigned integer components: 10-bit red, 10-bit green, 10-bit blue, and 2-bit alpha.
    RGB10A2Uint = 91,
    ///32-bit format with floating-point color components, 11 bits each for red and green and 10 bits for blue.
    RG11B10Float = 92,
    ///Packed 32-bit format with floating-point color components: 9 bits each for RGB and 5 bits for an exponent shared by RGB, packed into 32 bits.
    RGB9E5Float = 93,
    ///Ordinary format with two 32-bit unsigned integer components.
    RG32Uint = 103,
    ///Ordinary format with two 32-bit signed integer components.
    RG32Sint = 104,
    ///Ordinary format with two 32-bit floating-point components.
    RG32Float = 105,
    ///Ordinary format with four 16-bit normalized unsigned integer components in RGBA order.
    RGBA16Unorm = 110,
    ///Ordinary format with four 16-bit normalized signed integer components in RGBA order.
    RGBA16Snorm = 112,
    ///Ordinary format with four 16-bit unsigned integer components in RGBA order.
    RGBA16Uint = 113,
    ///Ordinary format with four 16-bit signed integer components in RGBA order.
    RGBA16Sint = 114,
    ///Ordinary format with four 16-bit floating-point components in RGBA order.
    RGBA16Float = 115,

    ///A pixel format with a 16-bit normalized unsigned integer component, used for a depth render target.
    Depth16Unorm = 250,
    ///A pixel format with one 32-bit floating-point component, used for a depth render target.
    Depth32Float = 252,
    ///A pixel format with an 8-bit unsigned integer component, used for a stencil render target.
    Stencil8 = 253,
    ///A 32-bit combined depth and stencil pixel format with a 24-bit normalized unsigned integer for depth and an 8-bit unsigned integer for stencil.
    Depth24Unorm_Stencil8 = 255,
    ///A 40-bit combined depth and stencil pixel format with a 32-bit floating-point value for depth and an 8-bit unsigned integer for stencil.
    Depth32Float_Stencil8 = 260,
    ///A stencil pixel format used to read the stencil value from a texture with a combined 32-bit depth and 8-bit stencil value.
    X32_Stencil8 = 261,
    ///A stencil pixel format used to read the stencil value from a texture with a combined 24-bit depth and 8-bit stencil value.
    X24_Stencil8 = 262,

    ///The default value of the pixel format for the MTLRenderPipelineState. You cannot create a texture with this value.
    Invalid = 0

}