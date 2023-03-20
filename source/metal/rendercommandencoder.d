module metal.rendercommandencoder;

version(D_ObjectiveC):
extern(Objective-C):
import metal.metal;
import metal.texture;

///The type of a top-level Metal Shading Language (MSL) function.
enum MTLFunctionType : NSUInteger
{
    ///A vertex function you can use in a render pipeline state object.
    Vertex = 1,
    ///A fragment function you can use in a render pipeline state object.
    Fragment = 2,
    ///A kernel you can use in a compute pipeline state object.
    Kernel = 3,
    ///A function you can use in an intersection function table.
    Intersection = 6,
    ///A function you can use in a visible function table.
    Visible = 5,
    Mesh = 7,
    Object = 8
}

///An object representing a function that you can add to a visible function table.
extern interface MTLFunctionHandle
{
    ///The device object that created the shader function.
    @selector("device")
    MTLDevice device();

    ///The shader function’s type.
    @selector("functionType")
    MTLFunctionType functionType();

    @selector("name")
    NSString name();

}

///A collection of model data for GPU-accelerated intersection of rays with the model.
extern interface MTLAccelerationStructure
{
    ///The size of the acceleration structure’s memory allocation, in bytes.
    @selector("size")
    NSUInteger size();

    // MTLResourceID gpuResourceID();
}

///A table of intersection functions that Metal calls to perform ray-tracing intersection tests.
extern interface MTLIntersectionFunctionTable
{
    ///Sets an entry in the table.
    @selector("setFunction:atIndex:")
    void setFunction(MTLFunctionHandle, NSUInteger index);
}

///A table of shader functions visible to your app that you can pass into compute commands to customize the behavior of a shader.
extern interface MTLVisibleFunctionTable
{
    ///Sets a table entry to point to a callable function.
    @selector("setFunction:atIndex:")
    void setFunction(MTLFunctionHandle, NSUInteger index);

    ///Sets a range of table entries to point to an array of callable functions.
    @selector("setFunctions:withRange:")
    void setFunctions(const(MTLFunctionHandle)*, NSRange range);

    // MTLResourceID gpuResourceID();
}

struct MTLVertexAmplificationViewMapping
{
    ///An offset into the list of render targets.
    uint renderTargetArrayIndexOffset;
    ///An offset into the list of viewports.
    uint viewportArrayIndexOffset;
}

extern interface MTLRenderCommandEncoder : MTLCommandEncoder
{
    @selector("setViewport:")
    void setViewport(MTLViewport);

    ///Sets the current render pipeline state object.
    @selector("setRenderPipelineState:")
    void setRenderPipelineState(MTLRenderPipelineState pipelineState);

    ///Sets how to rasterize triangle and triangle strip primitives.
    @selector("setTriangleFillMode:")
    void setTriangleFillMode(MTLTriangleFillMode);

    ///Sets the winding order of front-facing primitives.
    @selector("setFrontFaceWinding:")
    void setFrontFaceWinding(MTLWinding);

    ///Specifies whether to cull primitives when front- or back-facing.
    @selector("setCullMode:")
    void setCullMode(MTLCullMode);

    ///Sets a buffer for the vertex function.
    @selector("setVertexBuffer:offset:atIndex:")
    void setVertexBuffer(MTLBuffer vertexBuffer, NSUInteger offset, NSUInteger index);

    ///Sets an array of buffers for the vertex function.
    @selector("setVertexBuffers:offsets:withRange:")
    void setVertexBuffers(const(MTLBuffer)* buffers, const(NSUInteger)* offsets, NSRange range);

    ///Sets where the data begins in a buffer already bound to the vertex shader.
    @selector("setVertexBufferOffset:atIndex:")
    void setVertexBufferOffset(NSUInteger offset, NSUInteger index);

    ///Sets a block of data for the vertex shader.
    @selector("setVertexBytes:length:atIndex:")
    void setVertexBytes(const(void)* bytes, NSUInteger length, NSUInteger index);

    ///Sets a sampler for the vertex function.
    // @selector("setVertexSamplerState:atIndex:")
    // void setVertexSamplerState(MTLSamplerState sampler, NSUInteger index);

    ///Sets a sampler for the vertex function, specifying clamp values for the level of detail.
    @selector("setVertexSamplerState:lodMinClamp:lodMaxClamp:atIndex:")
    void setVertexSamplerState(MTLSamplerState state, float lodMinClamp, float lodMaxClamp, NSUInteger index);

    ///Sets multiple samplers for the vertex function.
    @selector("setVertexSamplerStates:withRange:")
    void setVertexSamplerStates(const(MTLSamplerState)* samplers, NSRange range);

    ///Sets multiple samplers for the vertex function, specifying clamp values for the level of detail of each sampler.
    @selector("setVertexSamplerStates:lodMinClamps:lodMaxClamps:withRange:")
    void setVertexSamplerStates(
        const(MTLSamplerState)* samplers, 
        const(float)* lodMinClamps,
        const(float)* lodMaxClamps,
        NSRange range
    );

    ///Sets a texture for the vertex function.
    @selector("setVertexTexture:atIndex:")
    void setVertexTexture(MTLTexture texture, NSUInteger index);

    ///Sets an array of textures for the vertex function.
    @selector("setVertexTextures:withRange:")
    void setVertexTextures(const(MTLTexture)* textures, NSRange range);

    ///Sets a visible function table for the vertex function.
    @selector("setVertexVisibleFunctionTable:atBufferIndex:")
    void setVertexVisibleFunctionTable(MTLVisibleFunctionTable, NSUInteger bufferIndex);

    ///Sets an array of visible function tables for the vertex function.
    @selector("setVertexVisibleFunctionTables:withBufferRange:")
    void setVertexVisibleFunctionTables(const(MTLVisibleFunctionTable)*, NSRange range);

    ///Sets a intersection function table for the vertex function.
    @selector("setVertexIntersectionFunctionTable:atBufferIndex:")
    void setVertexIntersectionFunctionTable(MTLIntersectionFunctionTable, NSUInteger index);

    ///Sets an array of intersection function tables for the vertex function.
    @selector("setVertexIntersectionFunctionTables:withBufferRange:")
    void setVertexIntersectionFunctionTables(const(MTLIntersectionFunctionTable)*, NSRange range);

    ///Sets an acceleration structure for the vertex function.
    @selector("setVertexAccelerationStructure:atBufferIndex:")
    void setVertexAccelerationStructure(MTLAccelerationStructure, NSUInteger bufferIndex);

    ///Sets a buffer for the fragment function.
    @selector("setFragmentBuffer:offset:atIndex:")
    void setFragmentBuffer(MTLBuffer, NSUInteger offset, NSUInteger index);
    
    ///Sets an array of buffers for the fragment function in a range of indices in the buffer argument table.
    @selector("setFragmentBuffers:offsets:withRange:")
    void setFragmentBuffers(const(MTLBuffer)*, const(NSUInteger)* offsets, NSRange range);

    ///Sets where the data begins in a buffer already bound to the fragment shader.
    @selector("setFragmentBufferOffset:atIndex:")
    void setFragmentBufferOffset(NSUInteger offset, NSInteger index);

    ///Sets a block of data for the fragment shader.
    @selector("setFragmentBytes:length:atIndex:")
    void setFragmentBytes(const(void)* bytes, NSUInteger length, NSUInteger index);

    ///Sets a sampler state for the fragment function at an index in the sampler state argument table.
    @selector("setFragmentSamplerState:atIndex:")
    void setFragmentSamplerState(MTLSamplerState, NSUInteger index);

    ///Sets an array of sampler states for the fragment function in a range of indices in the sampler state argument table.
    @selector("setFragmentSamplerStates:withRange:")
    void setFragmentSamplerStates(const(MTLSamplerState)*, NSRange range);

    ///Sets a sampler state for the fragment function at an index in the sampler state argument table, specifying clamp values for the minimum and maximum level of detail.
    @selector("setFragmentSamplerState:lodMinClamp:lodMaxClamp:atIndex:")
    void setFragmentSamplerState(MTLSamplerState, float lodMinClamp, float lodMaxClamp, NSUInteger index);

    ///Sets sampler states for the fragment function in a range of indices in the sampler state argument table, specifying clamp values for levels of detail.
    @selector("setFragmentSamplerStates:lodMinClamps:lodMaxClamps:withRange:")
    void setFragmentSamplerStates(
        const(MTLSamplerState)*, 
        const(float)* lodMinClamps,
        const(float)* lodMaxClamps,
        NSRange range
    );

    ///Sets a texture for the fragment function at an index in the texture argument table.
    @selector("setFragmentTexture:atIndex:")
    void setFragmentTexture(MTLTexture, NSUInteger index);

    ///Sets an array of textures for the fragment function in a range of indices in the texture argument table.
    @selector("setFragmentTextures:withRange:")
    void setFragmentTextures(const(MTLTexture)*, NSRange range);

    ///Sets a visible function table for the fragment function.
    @selector("setFragmentVisibleFunctionTable:atBufferIndex:")
    void setFragmentVisibleFunctionTable(MTLVisibleFunctionTable, NSUInteger bufferIndex);

    ///Sets an array of visible function tables for the fragment function.
    @selector("setFragmentVisibleFunctionTables:withBufferRange:")
    void setFragmentVisibleFunctionTables(const(MTLVisibleFunctionTable)*, NSRange range);

    ///Sets a intersection function table for the fragment function.
    @selector("setFragmentIntersectionFunctionTable:atBufferIndex:")
    void setFragmentIntersectionFunctionTable(MTLIntersectionFunctionTable, NSUInteger bufferIndex);

    ///Sets an array of intersection function tables for the fragment function.
    @selector("setFragmentIntersectionFunctionTables:withBufferRange:")
    void setFragmentIntersectionFunctionTables(const(MTLIntersectionFunctionTable*), NSRange range);

    ///Sets an acceleration structure for the fragment function.
    @selector("setFragmentAccelerationStructure:atBufferIndex:")
    void setFragmentAccelerationStructure(MTLAccelerationStructure, NSUInteger bufferIndex);

    ///Sets the per-patch tessellation factors buffer for the tessellator.
    @selector("setTessellationFactorBuffer:offset:instanceStride:")
    void setTessellationFactorBuffer(MTLBuffer, NSUInteger offset, NSUInteger instanceStride);

    ///Sets the scale factor applied to the per-patch tessellation factors.
    @selector("setTessellationFactorScale:")
    void setTessellationFactorScale(float);

    ///Sets the number of output vertices for each input vertex, along with offsets into the layer and viewport lists.
    @selector("setVertexAmplificationCount:viewMappings:")
    void setVertexAmplificationCount(NSUInteger count, const(MTLVertexAmplificationViewMapping)* viewMappings);

    ///Encodes a command to render a number of instances of primitives using vertex data in contiguous array elements, starting from the base instance.
    @selector("drawPrimitives:vertexStart:vertexCount:instanceCount:baseInstance:")
    void drawPrimitives(MTLPrimitiveType, NSUInteger vertexStart, NSUInteger vertexCount, NSUInteger instanceCount, NSUInteger baseInstance);

    ///Encodes a command to render a number of instances of primitives using vertex data in contiguous array elements.
    @selector("drawPrimitives:vertexStart:vertexCount:instanceCount:")
    void drawPrimitives(MTLPrimitiveType, NSUInteger vertexStart, NSUInteger vertexCount, NSUInteger instanceCount);

    ///Encodes a command to render one instance of primitives using vertex data in contiguous array elements.        
    @selector("drawPrimitives:vertexStart:vertexCount:")
    void drawPrimitives(MTLPrimitiveType, NSUInteger vertexStart, NSUInteger vertexCount);

    
    ///Encodes a command to render a number of instances of primitives using an index list specified in a buffer, starting from the base vertex of the base instance.
    @selector("drawIndexedPrimitives:indexCount:indexType:indexBuffer:indexBufferOffset:instanceCount:baseVertex:baseInstance:")
    void drawIndexedPrimitives(
        MTLPrimitiveType, 
        NSUInteger indexCount,
        MTLIndexType indexType,
        MTLBuffer indexBuffer,
        NSUInteger indexBufferOffset,
        NSUInteger instanceCount,
        NSInteger baseVertex,
        NSUInteger baseInstance,
    );

    ///Encodes a command to render a number of instances of primitives using an index list specified in a buffer.
    @selector("drawIndexedPrimitives:indexCount:indexType:indexBuffer:indexBufferOffset:instanceCount:")
    void drawIndexedPrimitives(
        MTLPrimitiveType, 
        NSUInteger indexCount,
        MTLIndexType indexType,
        MTLBuffer indexBuffer,
        NSUInteger indexBufferOffset,
        NSUInteger instanceCount,
    );

    ///Encodes a command to render one instance of primitives using an index list specified in a buffer.
    @selector("drawIndexedPrimitives:indexCount:indexType:indexBuffer:indexBufferOffset:")
    void drawIndexedPrimitives(
        MTLPrimitiveType, 
        NSUInteger indexCount,
        MTLIndexType indexType,
        MTLBuffer indexBuffer,
        NSUInteger indexBufferOffset,
    );

    ///Encodes a command to render a number of instances of tessellated patches.
    @selector("drawPatches:patchStart:patchCount:patchIndexBuffer:patchIndexBufferOffset:instanceCount:baseInstance:")
    void drawPatches(
        NSUInteger numberOfPatchControlPoints,
        NSUInteger patchStart,
        NSUInteger patchCount,
        MTLBuffer patchIndexBuffer,
        NSUInteger patchIndexBufferOffset,
        NSUInteger instanceCount,
        NSUInteger baseInstance,
    );

    ///Encodes a command to render a number of instances of tessellated patches, using a control point index buffer.
    @selector("drawIndexedPatches:patchStart:patchCount:patchIndexBuffer:patchIndexBufferOffset:controlPointIndexBuffer:controlPointIndexBufferOffset:instanceCount:baseInstance:")
    void drawIndexedPatches(
        NSUInteger numberOfPatchControlPoints,
        NSUInteger patchStart,
        NSUInteger patchCount,
        MTLBuffer patchIndexBuffer,
        NSUInteger patchIndexBufferOffset,
        MTLBuffer controlPointIndexBuffer,
        NSUInteger controlPointIndexBufferOffset,
        NSUInteger instanceCount,
        NSUInteger baseInstance,
    );
    ///Declares that all command generation from the encoder is completed.
    @selector("endEncoding")
    void endEncoding();
}
