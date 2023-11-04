module metal.vertexdescriptor;
import objc.runtime;
import objc.meta : selector, ObjcExtend;

version(D_ObjectiveC):
@ObjectiveC:


enum MTLVertexFormat : uint
{
    ///An invalid vertex format.
    invalid,
    ///One unsigned 8-bit value.
    uchar = 45,
    ///Two unsigned 8-bit values.
    uchar2 = 1,
    ///Three unsigned 8-bit values.
    uchar3 = 2,
    ///Four unsigned 8-bit values.
    uchar4 = 3,
    ///One signed 8-bit two's complement value.
    char1 = 46,
    ///Two signed 8-bit two's complement values.
    char2 = 4,
    ///Three signed 8-bit two's complement values.
    char3 = 5,
    ///Four signed 8-bit two's complement values.
    char4 = 6,
    ///One unsigned normalized 8-bit value.
    ucharNormalized = 47,
    ///Two unsigned normalized 8-bit values.
    uchar2Normalized = 7,
    ///Three unsigned normalized 8-bit values.
    uchar3Normalized = 8,
    ///Four unsigned normalized 8-bit values.
    uchar4Normalized = 9,
    ///One signed normalized 8-bit two's complement value.
    charNormalized = 48,
    ///Two signed normalized 8-bit two's complement values.
    char2Normalized = 10,
    ///Three signed normalized 8-bit two's complement values.
    char3Normalized = 11,
    ///Four signed normalized 8-bit two's complement values.
    char4Normalized = 12,
    ///One unsigned 16-bit value.
    ushort1 = 49,
    ///Two unsigned 16-bit values.
    ushort2 = 13,
    ///Three unsigned 16-bit values.
    ushort3 = 14,
    ///Four unsigned 16-bit values.
    ushort4 = 15,
    ///One signed 16-bit two's complement value.
    short1 = 50,
    ///Two signed 16-bit two's complement values.
    short2 = 16,
    ///Three signed 16-bit two's complement values.
    short3 = 17,
    ///Four signed 16-bit two's complement values.
    short4 = 18,
    ///One unsigned normalized 16-bit value.
    ushortNormalized = 51,
    ///Two unsigned normalized 16-bit values.
    ushort2Normalized = 19,
    ///Three unsigned normalized 16-bit values.
    ushort3Normalized = 20,
    ///Four unsigned normalized 16-bit values.
    ushort4Normalized = 21,
    ///One signed normalized 16-bit two's complement value.
    shortNormalized = 52,
    ///Two signed normalized 16-bit two's complement values.
    short2Normalized = 22,
    ///Three signed normalized 16-bit two's complement values.
    short3Normalized = 23,
    ///Four signed normalized 16-bit two's complement values.
    short4Normalized = 24,
    ///One half-precision floating-point value.
    half1 = 53,
    ///Two half-precision floating-point values.
    half2 = 25,
    ///Three half-precision floating-point values.
    half3 = 26,
    ///Four half-precision floating-point values.
    half4 = 27,
    ///One single-precision floating-point value.
    float1 = 28,
    ///Two single-precision floating-point values.
    float2 = 29,
    ///Three single-precision floating-point values.
    float3 = 30,
    ///Four single-precision floating-point values.
    float4 = 31,
    ///One unsigned 32-bit value.
    uint1 = 36,
    ///Two unsigned 32-bit values.
    uint2 = 37,
    ///Three unsigned 32-bit values.
    uint3 = 38,
    ///Four unsigned 32-bit values.
    uint4 = 39,
    ///One signed 32-bit two's complement value.
    int1 = 32,
    ///Two signed 32-bit two's complement values.
    int2 = 33,
    ///Three signed 32-bit two's complement values.
    int3 = 34,
    ///Four signed 32-bit two's complement values.
    int4 = 35,
    ///One packed 32-bit value with four normalized signed two's complement integer values, arranged as 10 bits, 10 bits, 10 bits, and 2 bits.
    int1010102Normalized = 40,
    ///One packed 32-bit value with four normalized unsigned integer values, arranged as 10 bits, 10 bits, 10 bits, and 2 bits.
    uint1010102Normalized = 41,
    ///Four unsigned normalized 8-bit values, arranged as blue, green, red, and alpha components.
    uchar4Normalized_bgra = 42,
}


///An object that determines how to store attribute data in memory and map it to the arguments of a vertex function.
class MTLVertexAttributeDescriptor : NSObject
{
    mixin ObjcExtend;
    ///The format of the vertex attribute.
    @selector("format")
    MTLVertexFormat format();

    @selector("setFormat:")
    MTLVertexFormat format(MTLVertexFormat);

    ///The location of an attribute in vertex data, determined by the byte offset from the start of the vertex data.
    @selector("offset")
    NSUInteger offset();
    @selector("setOffset:")
    NSUInteger offset(NSUInteger);

    ///The index in the argument table for the associated vertex buffer.
    @selector("bufferIndex")
    NSUInteger bufferIndex();
    @selector("setBufferIndex:")
    NSUInteger bufferIndex(NSUInteger);
}

class MTLVertexAttributeDescriptorArray : NSObject
{
    mixin ObjcExtend;
    ///Returns the state of the specified vertex attribute.
    @selector("objectAtIndexedSubscript:")
    MTLVertexAttributeDescriptor objectAtIndexedSubscript(NSUInteger index);

    ///Sets state for the specified vertex attribute.
    @selector("setObject:atIndexedSubscript:")
    void setObjectAtIndexedSubscript(MTLVertexAttributeDescriptor descriptor, NSUInteger index);

    extern(D) final MTLVertexAttributeDescriptor opIndex(NSUInteger index)
    {
        return objectAtIndexedSubscript(index);
    }
    extern(D) final void opIndexAssign(MTLVertexAttributeDescriptor v, NSUInteger index)
    {
        setObjectAtIndexedSubscript(v, index);
    }
}

///The frequency with which the vertex function or post-tessellation vertex function fetches attribute data.
enum MTLVertexStepFunction : NSUInteger
{
    ///The vertex function fetches attribute data once and uses that data for every vertex.
    Constant = 0,
    ///The vertex function fetches and uses new attribute data for every vertex.
    PerVertex = 1,
    ///The vertex function regularly fetches new attribute data for a number of instances that is determined by stepRate.
    PerInstance = 2,
    ///The post-tessellation vertex function fetches data based on the patch index of the patch.
    PerPatch = 3,
    ///The post-tessellation vertex function fetches data based on the control-point indices associated with the patch.
    PerPatchControlPoint = 4
}

///An object that configures how a render pipeline fetches data to send to the vertex function.
class MTLVertexBufferLayoutDescriptor : NSObject
{
    mixin ObjcExtend;
    ///The circumstances under which the vertex and its attributes are presented to the vertex function.
    @selector("stepFunction")
    MTLVertexStepFunction stepFunction();
    @selector("setStepFunction:")
    MTLVertexStepFunction stepFunction(MTLVertexStepFunction);

    ///The interval at which the vertex and its attributes are presented to the vertex function.
    @selector("stepRate")
    NSUInteger stepRate();
    @selector("setStepRate:")
    NSUInteger stepRate(NSUInteger);

    ///The distance, in bytes, between the attribute data of two vertices in the buffer.
    @selector("stride")
    NSUInteger stride();
    @selector("setStride:")
    NSUInteger stride(NSUInteger);
}

class MTLVertexBufferLayoutDescriptorArray : NSObject
{
    mixin ObjcExtend;
    ///Returns the state of the specified vertex buffer layout.
    @selector("objectAtIndexedSubscript:")
    MTLVertexBufferLayoutDescriptor objectAtIndexedSubscript(NSUInteger index);

    ///Sets the state of the specified vertex buffer layout.
    @selector("setObject:atIndexedSubscript:")
    void setObjectAtIndexedSubscript(MTLVertexBufferLayoutDescriptor bufferDesc, NSUInteger index);

    extern(D) final MTLVertexBufferLayoutDescriptor opIndex(NSUInteger index)
    {
        return objectAtIndexedSubscript(index);       
    }
    extern(D) final void opIndexAssign(MTLVertexBufferLayoutDescriptor value, NSUInteger index)
    {
        setObjectAtIndexedSubscript(value, index);
    }
}

class MTLVertexDescriptor : NSObject
{
    mixin ObjcExtend;
    ///Creates and returns a new vertex descriptor.
    static MTLVertexDescriptor vertexDescriptor() @selector("vertexDescriptor");
    ///Resets the default state for the vertex descriptor.
    void reset() @selector("reset");

    ///An array of state data that describes how vertex attribute data is stored in memory and is mapped to arguments for a vertex shader function.
    MTLVertexAttributeDescriptorArray attributes() @selector("attributes");

    ///An array of state data that describes how data are fetched by a vertex shader function when rendering primitives.
    MTLVertexBufferLayoutDescriptorArray layouts() @selector("layouts");
}
