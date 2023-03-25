module metal.texture;

version(D_ObjectiveC):
extern(Objective-C):

import metal.metal;
import metal.pixelformat;


///Modes that determine the texture coordinate at each pixel when a fetch falls outside the bounds of a texture.
enum MTLSamplerAddressMode : NSUInteger
{
    ///Texture coordinates are clamped between 0.0 and 1.0, inclusive.
    ClampToEdge = 0,
    ///Between -1.0 and 1.0, the texture coordinates are mirrored across the axis; outside -1.0 and 1.0, texture coordinates are clamped.
    MirrorClampToEdge = 1,
    ///Texture coordinates wrap to the other side of the texture, effectively keeping only the fractional part of the texture coordinate.
    Repeat = 2,
    ///Between -1.0 and 1.0, the texture coordinates are mirrored across the axis; outside -1.0 and 1.0, the image is repeated.
    MirrorRepeat = 3,
    ///Out-of-range texture coordinates return transparent zero (0,0,0,0) for images with an alpha channel and return opaque zero (0,0,0,1) for images without an alpha channel.
    ClampToZero = 4,
    ///Out-of-range texture coordinates return the value specified by the borderColor property.
    ClampToBorderColor = 5
}

///Values that determine the border color for clamped texture values when the sampler address mode is MTLSamplerAddressModeClampToBorderColor.
enum MTLSamplerBorderColor : NSUInteger
{
    ///A transparent black color (0,0,0,0) for texture values outside the border.
    TransparentBlack = 0,
    ///An opaque black color (0,0,0,1) for texture values outside the border
    OpaqueBlack = 1,
    ///An opaque white color (1,1,1,1) for texture values outside the border.
    OpaqueWhite = 2
}

///Filtering options for determining which pixel value is returned within a mipmap level.
enum MTLSamplerMinMagFilter : NSUInteger
{
    ///Select the single pixel nearest to the sample point.
    Nearest = 0,
    ///Select two pixels in each dimension and interpolate linearly between them.
    Linear = 1
}

///Filtering options for determining what pixel value is returned with multiple mipmap levels.
enum MTLSamplerMipFilter : NSUInteger
{
    ///The texture is sampled from mipmap level 0, and other mipmap levels are ignored.
    NotMipmapped = 0,
    ///The nearest mipmap level is selected.
    Nearest = 1,
    ///If the filter falls between mipmap levels, both levels are sampled and the results are determined by linear interpolation between levels.
    Linear = 2   
}

///Options used to specify how a sample compare operation should be performed on a depth texture.
enum MTLCompareFunction : NSUInteger
{
    ///A new value never passes the comparison test.
    Never = 0,
    ///A new value passes the comparison test if it is less than the existing value.
    Less = 1,
    ///A new value passes the comparison test if it is equal to the existing value.
    Equal = 2,
    ///A new value passes the comparison test if it is less than or equal to the existing value.
    LessEqual = 3,
    ///A new value passes the comparison test if it is greater than the existing value.
    Greater = 4,
    ///A new value passes the comparison test if it is not equal to the existing value.
    NotEqual = 5,
    ///A new value passes the comparison test if it is greater than or equal to the existing value.
    GreaterEqual = 6,
    ///A new value always passes the comparison test.
    Always = 7

}

///An object that you use to configure a texture sampler.
extern class MTLSamplerDescriptor : NSObject
{
    @selector("alloc")
    override static MTLSamplerDescriptor alloc();
    @selector("init")
    override MTLSamplerDescriptor initialize();

    ///A Boolean value that indicates whether texture coordinates are normalized to the range [0.0, 1.0].
    @selector("normalizedCoordinates")
    BOOL normalizedCoordinates();

    ///The address mode for the texture depth (r) coordinate.
    @selector("rAddressMode")
    MTLSamplerAddressMode rAddressMode();
    @selector("setRAddressMode:")
    MTLSamplerAddressMode rAddressMode(MTLSamplerAddressMode);

    ///The address mode for the texture width (s) coordinate.
    @selector("sAddressMode")
    MTLSamplerAddressMode sAddressMode();
    @selector("setSAddressMode:")
    MTLSamplerAddressMode sAddressMode(MTLSamplerAddressMode);

    ///The address mode for the texture height (t) coordinate.
    @selector("tAddressMode")
    MTLSamplerAddressMode tAddressMode();
    @selector("setTAddressMode:")
    MTLSamplerAddressMode tAddressMode(MTLSamplerAddressMode);

    ///The border color for clamped texture values.
    @selector("borderColor")
    MTLSamplerBorderColor borderColor();
    @selector("setBorderColor:")
    MTLSamplerBorderColor borderColor(MTLSamplerBorderColor);

    ///The filtering option for combining pixels within one mipmap level when the sample footprint is larger than a pixel (minification).
    @selector("minFilter")
    MTLSamplerMinMagFilter minFilter();
    @selector("setMinFilter:")
    MTLSamplerMinMagFilter minFilter(MTLSamplerMinMagFilter);

    ///The filtering operation for combining pixels within one mipmap level when the sample footprint is smaller than a pixel (magnification).
    @selector("magFilter")
    MTLSamplerMinMagFilter magFilter();
    @selector("setMagFilter:")
    MTLSamplerMinMagFilter magFilter(MTLSamplerMinMagFilter);

    ///The filtering option for combining pixels between two mipmap levels.
    @selector("mipFilter")
    MTLSamplerMipFilter mipFilter();
    @selector("setMipFilter:")
    MTLSamplerMipFilter mipFilter(MTLSamplerMipFilter);

    ///The minimum level of detail (LOD) to use when sampling from a texture.
    @selector("lodMinClamp")
    float lodMinClamp();
    @selector("setLodMinClamp:")
    float lodMinClamp(float);

    ///The maximum level of detail (LOD) to use when sampling from a texture.
    @selector("lodMaxClamp")
    float lodMaxClamp();
    @selector("setLodMaxClamp:")
    float lodMaxClamp(float);

    ///A Boolean value that specifies whether the GPU can use an average level of detail (LOD) when sampling from a texture.
    @selector("lodAverage")
    BOOL lodAverage();
    @selector("setlodAverage:")
    BOOL lodAverage(BOOL);
    
    ///The number of samples that can be taken to improve the quality of sample footprints that are anisotropic.
    @selector("maxAnisotropy")
    NSUInteger maxAnisotropy();
    @selector("setMaxAnisotropy:")
    NSUInteger maxAnisotropy(NSUInteger);


    ///The sampler comparison function used when performing a sample compare operation on a depth texture.
    @selector("compareFunction")
    MTLCompareFunction compareFunction();
    @selector("setCompareFunction:")
    MTLCompareFunction compareFunction(MTLCompareFunction);


    ///A Boolean value that specifies whether the sampler can be encoded into an argument buffer.
    @selector("supportArgumentBuffers")
    BOOL supportArgumentBuffers();
    @selector("setSupportArgumentBuffers:")
    BOOL supportArgumentBuffers(BOOL);

    ///A string that identifies the sampler.
    @selector("label")
    NSString label();
    @selector("setLabel:")
    NSString label(NSString);


}

private extern(C) MTLSamplerState _D41TypeInfo_C5metal7texture15MTLSamplerState6__initZ = null;
///An object that defines how a texture should be sampled.
extern interface MTLSamplerState
{
    ///The device object that created the sampler.
    @selector("device")
    MTLDevice device();

    ///A string that identifies the sampler.
    @selector("label")
    NSString label();

    @selector("release")
    void release();
}

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

///An object that you use to configure new Metal texture objects.
extern class MTLTextureDescriptor : NSObject
{
    @selector("alloc")
    override static MTLTextureDescriptor alloc();
    @selector("init")
    override MTLTextureDescriptor initialize();
    
    ///Creates a texture descriptor object for a 2D texture.
    @selector("texture2DDescriptorWithPixelFormat:width:height:mipmapped:")
    static MTLTextureDescriptor texture2DDescriptorWithPixelFormat(
        MTLPixelFormat, 
        NSUInteger width, 
        NSUInteger height, 
        BOOL mipmapped
    );

    ///Creates a texture descriptor object for a cube texture.
    @selector("textureCubeDescriptorWithPixelFormat:size:mipmapped:")
    static MTLTextureDescriptor textureCubeDescriptorWithPixelFormat(
        MTLPixelFormat,
        NSUInteger size,
        BOOL mipmapped
    );

    ///Creates a texture descriptor object for a texture buffer.
    @selector("textureBufferDescriptorWithPixelFormat:width:resourceOptions:usage:")
    static MTLTextureDescriptor textureBufferDescriptorWithPixelFormat(
        MTLPixelFormat,
        NSUInteger width,
        MTLResourceOptions resourceOptions,
        MTLTextureUsage usage,
    );
    
    ///The dimension and arrangement of texture image data.
    @selector("textureType")
    MTLTextureType textureType();
    @selector("setTextureType:")
    MTLTextureType textureType(MTLTextureType);

    ///The size and bit layout of all pixels in the texture.
    @selector("pixelFormat")
    MTLPixelFormat pixelFormat();
    @selector("setPixelFormat:")
    MTLPixelFormat pixelFormat(MTLPixelFormat);

    ///The width of the texture image for the base level mipmap, in pixels.
    @selector("width")
    NSUInteger width();
    @selector("setWidth:")
    NSUInteger width(NSUInteger);

    ///The height of the texture image for the base level mipmap, in pixels.
    @selector("height")
    NSUInteger height();
    @selector("setHeight:")
    NSUInteger height(NSUInteger);

    ///The depth of the texture image for the base level mipmap, in pixels.
    @selector("depth")
    NSUInteger depth();
    @selector("setDepth:")
    NSUInteger depth(NSUInteger);

    ///The number of mipmap levels for this texture.
    @selector("mipmapLevelCount")
    NSUInteger mipmapLevelCount();
    @selector("setMipmapLevelCount:")
    NSUInteger mipmapLevelCount(NSUInteger);

    ///The number of samples in each fragment.
    @selector("sampleCount")
    NSUInteger sampleCount();
    @selector("setSampleCount:")
    NSUInteger sampleCount(NSUInteger);

    ///The number of array elements for this texture.
    @selector("arrayLength")
    NSUInteger arrayLength();
    @selector("setArrayLength:")
    NSUInteger arrayLength(NSUInteger);

    ///The behavior of a new memory allocation.
    @selector("resourceOptions")
    MTLResourceOptions resourceOptions();
    @selector("setResourceOptions:")
    MTLResourceOptions resourceOptions(MTLResourceOptions);

    ///The CPU cache mode used for the CPU mapping of the texture.
    @selector("cpuCacheMode")
    MTLCPUCacheMode cpuCacheMode();
    @selector("setCpuCacheMode:")
    MTLCPUCacheMode cpuCacheMode(MTLCPUCacheMode);

    ///The location and access permissions of the texture.
    @selector("storageMode")
    MTLStorageMode storageMode();
    @selector("setStorageMode:")
    MTLStorageMode storageMode(MTLStorageMode);

    ///The texture's hazard tracking mode.
    @selector("hazardTrackingMode")
    MTLHazardTrackingMode hazardTrackingMode();
    @selector("setHazardTrackingMode:")
    MTLHazardTrackingMode hazardTrackingMode(MTLHazardTrackingMode);

    ///A Boolean value indicating whether the GPU is allowed to adjust the texture's contents to improve GPU performance.
    @selector("allowGPUOptimizedContents")
    BOOL allowGPUOptimizedContents();
    @selector("setAllowGPUOptimizedContents:")
    BOOL allowGPUOptimizedContents(BOOL);

    ///Options that determine how you can use the texture.
    @selector("usage")
    MTLTextureUsage usage();
    @selector("setUsage:")
    MTLTextureUsage usage(MTLTextureUsage);

    ///The pattern you want the GPU to apply to pixels when you read or sample pixels from the texture.
    @selector("swizzle")
    MTLTextureSwizzleChannels swizzle();
    @selector("setSwizzle:")
    MTLTextureSwizzleChannels swizzle(MTLTextureSwizzleChannels);

}

private extern(C) void* _D36TypeInfo_C5metal7texture10MTLTexture6__initZ = null;
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