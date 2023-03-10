module metal.texture;

version(D_ObjectiveC):
extern(Objective-C):

import metal.metal;
import metal.pixelformat;

///A set of options to choose from when creating a texture swizzle pattern.
enum MTLTextureSwizzle : ubyte
{
    ///The alpha channel of the source pixel is copied to the destination channel.
    Alpha = 5,
    ///The blue channel of the source pixel is copied to the destination channel.
    Blue = 4,
    ///The green channel of the source pixel is copied to the destination channel.
    Green = 3,
    ///The red channel of the source pixel is copied to the destination channel.
    Red = 2,
    ///A value of 1.0 is copied to the destination channel.
    One = 1,
    ///A value of 0.0 is copied to the destination channel.
    Zero = 0
}

extern(C) MTLTextureSwizzleChannels MTLTextureSwizzleChannelsMake(MTLTextureSwizzle r, MTLTextureSwizzle g, MTLTextureSwizzle b, MTLTextureSwizzle a);

///A pattern that modifies the data read or sampled from a texture by rearranging or duplicating the elements of a vector.
struct MTLTextureSwizzleChannels
{
    MTLTextureSwizzle red;
    MTLTextureSwizzle green;
    MTLTextureSwizzle blue;
    MTLTextureSwizzle alpha;
}


///The dimension of each image, including whether multiple images are arranged into an array or a cube.
enum MTLTextureType : NSUInteger
{
    ///A one-dimensional texture image.
    _1D = 0,
    ///An array of one-dimensional texture images.
    _1DArray = 1,
    ///A two-dimensional texture image.
    _2D = 2,
    ///An array of two-dimensional texture images.
    _2DArray = 3,
    ///A two-dimensional texture image that uses more than one sample for each pixel.
    _2DMultisample = 4,
    ///A cube texture with six two-dimensional images.
    Cube = 5,
    //An array of cube textures, each with six two-dimensional images.
    CubeArray = 6,
    ///A three-dimensional texture image.
    _3D = 7,
    ///An array of two-dimensional texture images that use more than one sample for each pixel.
    _2DMultisampleArray = 8,
    ///A texture buffer.
    TextureBuffer = 9
}

///An enumeration for the various options that determine how you can use a texture.
enum MTLTextureUsage : NSUInteger
{
    ///An enumeration for the various options that determine how you can use a texture.
    Unknown         = 0x0000,
    ///An option for reading or sampling from the texture in a shader.
    ShaderRead      = 0x0001,
    ///An option for writing to the texture in a shader.
    ShaderWrite     = 0x0002,
    ///An option for rendering to the texture in a render pass.
    RenderTarget    = 0x0004,
    ///An option to create texture views with a different component layout.
    PixelFormatView = 0x0010
}

enum MTLTextureCompressionType : NSInteger
{
    Lossless = 0,
    Lossy = 1
}

///A resource that holds formatted image data.
extern interface MTLTexture
{
    ///Copies pixel data into a section of a texture slice.
    @selector("replaceRegion:mipmapLevel:slice:withBytes:bytesPerRow:bytesPerImage:")
    void replaceRegion(
        MTLRegion region, 
        NSUInteger mipmapLevel, 
        NSUInteger slice, 
        const(void)* withBytes,
        NSUInteger bytesPerRow, 
        NSUInteger bytesPerImage
    );

    ///Copies a block of pixels into a section of texture slice 0.
    @selector("replaceRegion:mipmapLevel:withBytes:bytesPerRow:")
    void replaceRegion(
        MTLRegion region,
        NSUInteger mipmapLevel,
        const(void)* withBytes,
        NSUInteger bytesPerRow
    );

    ///Copies pixel data from the texture to a buffer in system memory.
    @selector("getBytes:bytesPerRow:bytesPerImage:fromRegion:mipmapLevel:slice:")
    void getBytes(
        void* outPixelBytes,
        NSUInteger bytesPerRow,
        NSUInteger bytesPerImage,
        MTLRegion fromRegion,
        NSUInteger mipmapLevel,
        NSUInteger slice
    );

    ///Copies pixel data from the first slice of the texture to a buffer in system memory.
    @selector("getBytes:bytesPerRow:fromRegion:mipmapLevel:")
    void getBytes(
        void* outPixelBytes,
        NSUInteger bytesPerRow,
        MTLRegion fromRegion,
        NSUInteger mipmapLevel
    );

    ///Creates a new view of the texture, reinterpreting its data using a different pixel format.
    @selector("newTextureViewWithPixelFormat:")
    MTLTexture newTextureViewPixelFormat(MTLPixelFormat);

    ///Creates a new view of the texture, reinterpreting a subset of its data using a different type and pixel format.
    @selector("newTextureViewWithPixelFormat:textureType:levels:slices:")
    MTLTexture newTextureViewWithPixelFormat(
        MTLPixelFormat pixelFormat,
        MTLTextureType textureType,
        NSRange levelRange,
        NSRange sliceRange
    );
    ///Creates a new view of the texture, reinterpreting a subset of its data using a different type, pixel format, and swizzle pattern.
    @selector("newTextureViewWithPixelFormat:textureType:levels:slices:swizzle:")
    MTLTexture newTextureViewWithPixelFormat(
        MTLPixelFormat pixelFormat, 
        MTLTextureType textureType, 
        NSRange levelRange, 
        NSRange sliceRange, 
        MTLTextureSwizzleChannels swizzle
    );

    ///The dimension and arrangement of the texture image data.
    @selector("textureType")
    MTLTextureType textureType();

    ///The format of pixels in the texture.
    @selector("pixelFormat")
    MTLPixelFormat pixelFormat();

    ///The width of the texture image for the base level mipmap, in pixels.
    @selector("width")
    NSUInteger width();

    ///The height of the texture image for the base level mipmap, in pixels.
    @selector("height")
    NSUInteger height();

    ///The depth of the texture image for the base level mipmap, in pixels.
    @selector("depth")
    NSUInteger depth();

    ///The number of mipmap levels in the texture.
    @selector("mipmapLevelCount")
    NSUInteger mipmapLevelCount();

    ///The number of slices in the texture array.
    @selector("arrayLength")
    NSUInteger arrayLength();

    ///The number of samples in each pixel.
    @selector("sampleCount")
    NSUInteger sampleCount();

    ///A Boolean value that indicates whether the texture can only be used as a render target.
    @selector("framebufferOnly")
    BOOL framebufferOnly();
    alias isFramebufferOnly = framebufferOnly;

    ///Options that determine how you can use the texture.
    @selector("usage")
    MTLTextureUsage usage();

    ///A Boolean value indicating whether the GPU is allowed to adjust the contents of the texture to improve GPU performance.
    @selector("allowGPUOptimizedContents")
    BOOL allowGPUOptimizedContents();

    ///A Boolean indicating whether this texture can be shared with other processes.
    @selector("shareable")
    BOOL shareable();
    alias isShareable = shareable;

    ///The pattern that the GPU applies to pixels when you read or sample pixels from the texture.
    @selector("swizzle")
    MTLTextureSwizzleChannels swizzle();

    ///The parent texture that the texture was created from, if any.
    @selector("parentTexture")
    MTLTexture parentTexture();

    ///The base level of the parent texture that the texture was created from, if any.
    @selector("parentRelativeLevel")
    NSUInteger parentRelativeLevel();

    ///The base slice of the parent texture that the texture was created from, if any.
    @selector("parentRelativeSlice")
    NSUInteger parentRelativeSlice();

    ///The source buffer that the texture was created from, if any.
    @selector("buffer")
    MTLBuffer buffer();

    ///The offset in the source buffer where the texture's data comes from.
    @selector("offset")
    NSUInteger offset();

    ///The number of bytes in each row of the texture’s source buffer, if applicable.
    @selector("bufferBytesPerRow")
    NSUInteger bufferBytesPerRow();

    ///Creates a new texture handle from a shareable texture.
    //MTLSharedTextureHandle newSharedTextureHandle();

    ///Creates a remote texture view for another GPU in the same peer group.
    @selector("newRemoteTextureViewForDevice:")
    MTLTexture newRemoteTextureViewForDevice(MTLDevice);

    ///The texture on another GPU that the texture was created from, if any.
    @selector("remoteStorageTexture")
    MTLTexture remoteStorageTexture();

    ///A Boolean value that indicates whether this is a sparse texture.
    @selector("isSparse")
    BOOL isSparse();

    ///The index of the first mipmap in the tail.
    @selector("firstMipmapInTail")
    NSUInteger firstMipmapInTail();

    ///The size of the sparse texture tail, in bytes.
    @selector("tailSizeInBytes")
    NSUInteger tailSizeInBytes();

    @selector("compressionType")
    MTLTextureCompressionType compressionType();

    // MTLResourceID gpuResourceID();

}