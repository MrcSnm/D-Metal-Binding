module metal.blitcommandencoder;
version(D_ObjectiveC):
import objc.meta : selector;
import metal.metal;
import metal.texture;

@ObjectiveC:

///The options that enable behavior for some blit operations.
enum MTLBlitOption : NSUInteger
{
    ///A blit option that copies the depth portion of a combined depth and stencil texture to or from a buffer.
    DepthFromDepthStencil = 1 << 0,
    ///A blit option that copies the stencil portion of a combined depth and stencil texture to or from a buffer.
    StencilFromDepthStencil = 1 << 1,
    ///A blit option that copies PVRTC data between a texture and a buffer.
    RowLinearPVRTC = 1 << 2,
    ///A blit option that clears other blit options, which removes any optional behavior for a blit operation.
    None = 0
}

///An interface you can use to encode GPU commands that copy and modify the underlying memory of various Metal resources.
interface MTLBlitCommandEncoder : MTLCommandEncoder
{
    ///Encodes a command that fills a buffer with a constant value for each byte.
    @selector("fillBuffer:range:value:")
    void fillBuffer(MTLBuffer buffer, NSRange range, ubyte value);

    ///Encodes a command that generates mipmaps for a texture from the base mipmap level up to the highest mipmap level.
    @selector("generateMipmapsForTexture:")
    void generateMipmapsForTexture(MTLTexture);

    ///Encodes a command that copies data from one buffer into another.
    @selector("copyFromBuffer:sourceOffset:toBuffer:destinationOffset:size:")
    void copyFromBuffer(
        MTLBuffer sourceBuffer,
        NSUInteger sourceOffset,
        MTLBuffer destinationBuffer,
        NSUInteger destinationOffset,
        NSUInteger size
    );

    ///Encodes a command that copies data from one texture to another.
    @selector("copyFromTexture:toTexture:")
    void copyFromTexture(MTLTexture source, MTLTexture ddestination);

    ///Encodes a command that copies slices of a texture to another texture’s slices.
    @selector("copyFromTexture:sourceSlice:sourceLevel:toTexture:destinationSlice:destinationLevel:sliceCount:levelCount:")
    void copyFromTexture(
        MTLTexture sourceTexture, 
        NSUInteger sourceSlice,
        NSUInteger sourceLevel,
        MTLTexture destinationTexture,
        NSUInteger destinationSlice,
        NSUInteger destinationLevel,
        NSUInteger sliceCount,
        NSUInteger levelCount,
    );

    ///Encodes a command that copies image data from a texture’s slice into another slice.
    @selector("copyFromTexture:sourceSlice:sourceLevel:sourceOrigin:sourceSize:toTexture:destinationSlice:destinationLevel:destinationOrigin:")
    void copyFromTexture(
        MTLTexture sourceTexture,
        NSUInteger sourceSlice,
        NSUInteger sourceLevel,
        MTLOrigin sourceOrigin,
        MTLSize sourceSize,
        MTLTexture destinationTexture,
        NSUInteger destinationSlice,
        NSUInteger destinationLevel,
        MTLOrigin destinationOrigin,
    );

    ///Encodes a command to copy image data from a source buffer into a destination texture.
    @selector("copyFromBuffer:sourceOffset:sourceBytesPerRow:sourceBytesPerImage:sourceSize:toTexture:destinationSlice:destinationLevel:destinationOrigin:")
    void copyFromBuffer(MTLBuffer sourceBuffer,
        NSUInteger sourceOffset,
        NSUInteger sourceBytesPerRow,
        NSUInteger sourceBytesPerImage,
        MTLSize sourceSize,
        MTLTexture destinationTexture,
        NSUInteger destinationSlice,
        NSUInteger destinationLevel,
        MTLOrigin destinationOrigin,
    );

    ///Encodes a command to copy image data from a source buffer into a destination texture.
    @selector("copyFromBuffer:sourceOffset:sourceBytesPerRow:sourceBytesPerImage:sourceSize:toTexture:destinationSlice:destinationLevel:destinationOrigin:options:")
    void copyFromBuffer(MTLBuffer sourceBuffer,
        NSUInteger sourceOffset,
        NSUInteger sourceBytesPerRow,
        NSUInteger sourceBytesPerImage,
        MTLSize sourceSize,
        MTLTexture destinationTexture,
        NSUInteger destinationSlice,
        NSUInteger destinationLevel,
        MTLOrigin destinationOrigin,
        MTLBlitOption options,
    );

    ///Encodes a command that copies image data from a texture slice to a buffer.
    @selector("copyFromTexture:sourceSlice:sourceLevel:sourceOrigin:sourceSize:toBuffer:destinationOffset:destinationBytesPerRow:destinationBytesPerImage:")
    void copyFromTexture(MTLTexture sourceTexture, 
        NSUInteger sourceSlice,
        NSUInteger sourceLevel,
        MTLOrigin sourceOrigin,
        MTLSize sourceSize,
        MTLBuffer destinationBuffer,
        NSUInteger destinationOffset,
        NSUInteger destinationBytesPerRow,
        NSUInteger destinationBytesPerImage,
    );

    ///Encodes a command that copies image data from a texture slice to a buffer, and provides options for special texture formats.
    @selector("copyFromTexture:sourceSlice:sourceLevel:sourceOrigin:sourceSize:toBuffer:destinationOffset:destinationBytesPerRow:destinationBytesPerImage:options:")
    void copyFromTexture(MTLTexture sourceTexture, 
        NSUInteger sourceSlice,
        NSUInteger sourceLevel,
        MTLOrigin sourceOrigin,
        MTLSize sourceSize,
        MTLBuffer destinationBuffer,
        NSUInteger destinationOffset,
        NSUInteger destinationBytesPerRow,
        NSUInteger destinationBytesPerImage,
        MTLBlitOption options,
    );

    ///Encodes a command that improves the performance of the GPU’s accesses to a texture.
    @selector("optimizeContentsForGPUAccess:")
    void optimizeContentsForGPUAccess(MTLTexture texture);

    ///Encodes a command that improves the performance of the GPU’s accesses to a specific portion of a texture.
    @selector("optimizeContentsForGPUAccess:slice:level:")
    void optimizeContentsForGPUAccess(MTLTexture texture, 
        NSUInteger slice,
        NSUInteger level
    );

    ///Encodes a command that improves the performance of the CPU’s accesses to a texture.
    @selector("optimizeContentsForCPUAccess:")
    void optimizeContentsForCPUAccess(MTLTexture texture);

    ///Encodes a command that improves the performance of the CPU’s accesses to a specific portion of a texture.
    @selector("optimizeContentsForCPUAccess:slice:level:")
    void optimizeContentsForCPUAccess(MTLTexture texture, 
        NSUInteger slice,
        NSUInteger level
    );

    ///Encodes a command that synchronizes the CPU’s copy of a managed resource, such as a buffer or texture, so that it matches the GPU’s copy.
    @selector("synchronizeResource:")
    void synchronizeResource(MTLResource resource);

    ///Encodes a command that synchronizes a part of the CPU’s copy of a texture so that it matches the GPU’s copy.
    @selector("synchronizeTexture:slice:level:")
    void synchronizeTexture(MTLTexture texture,
        NSUInteger slice,
        NSUInteger level,
    );

    ///Encodes a command that instructs the GPU to update a fence, which can signal a pass that’s waiting for it.
    @selector("updateFence:")
    void updateFence(MTLFence);

    ///Encodes a command that instructs the GPU to wait until a pass updates a fence.
    @selector("waitForFence:")
    void waitForFence(MTLFence);

    // ///Encodes a command that copies commands from one indirect command buffer into another.
    // @selector("copyIndirectCommandBuffer:sourceRange:destination:destinationIndex:")
    // void copyIndirectCommandBuffer(MTLIndirectCommandBuffer source, 
    //     NSRange sourceRange,
    //     MTLIndirectCommandBuffer destination,
    //     NSUInteger destinationIndex,
    // );

    // ///Encodes a command that resets a range of commands in an indirect command buffer.
    // @selector("resetCommandsInBuffer:withRange:")
    // void resetCommandsInBuffer(MTLIndirectCommandBuffer buffer, NSRange range);

    // ///Encodes a command that can improve the performance of a range of commands within an indirect command buffer.
    // @selector("optimizeIndirectCommandBuffer:withRange:")
    // void optimizeIndirectCommandBuffer(
    //     MTLIndirectCommandBuffer indirectCommandBuffer, 
    //     NSRange range
    // );

    // ///Encodes a command that samples the GPU’s hardware counters during a blit pass and stores the data in a counter sample buffer.
    // @selector("sampleCountersInBuffer:atSampleIndex:withBarrier:")
    // void sampleCountersInBuffer(MTLCounterSampleBuffer sampleBuffer, 
    //     NSUInteger sampleIndex, 
    //     BOOL barrier,
    // );

    // ///Encodes a command that resolves the data from the samples in a sample counter buffer and stores the results into a buffer.
    // @selector("resolveCounters:inRange:destinationBuffer:destinationOffset:")
    // void resolveCounters(MTLCounterSampleBuffer sampleBuffer, 
    //     NSRange range,
    //     MTLBuffer destinationBuffer,
    //     NSUInteger destinationOffset,
    // );

    ///Encodes a command that retrieves a sparse texture’s access data for a specific region, mipmap level, and slice.
    @selector("getTextureAccessCounters:region:mipLevel:slice:resetCounters:countersBuffer:countersBufferOffset:")
    void getTextureAccessCounters(MTLTexture texture, 
        MTLRegion region,
        NSUInteger mipLevel,
        NSUInteger slice,
        BOOL resetCounters,
        MTLBuffer countersBuffer,
        NSUInteger countersBufferOffset,
    );

    ///Encodes a command that resets a sparse texture’s access data for a specific region, mipmap level, and slice.
    @selector("resetTextureAccessCounters:region:mipLevel:slice:")
    void resetTextureAccessCounters(MTLTexture texture,
        MTLRegion region,
        NSUInteger mipLevel,
        NSUInteger slice,
    );
}

