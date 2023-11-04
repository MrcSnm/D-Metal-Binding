module metal.library;
version(D_ObjectiveC): 
public import objc.runtime;
import objc.meta : selector, ObjcExtend;
import metal.metal;

@ObjectiveC:
enum MTLLanguageVersion : NSUInteger
{
    ///Deprecated
    _1_0 = (1 << 16) + 0,
    _1_1 = (1 << 16) + 1,
    _1_2 = (1 << 16) + 2,
    _2_0 = (2 << 16) + 0,
    _2_1 = (2 << 16) + 1,
    _2_2 = (2 << 16) + 2,
    _2_3 = (2 << 16) + 3,
    _2_4 = (2 << 16) + 4,
    _3_0 = (3 << 16) + 0,
}

enum MTLLibraryOptimizationLevel : NSInteger
{
    ///An optimization option for the Metal compiler that prioritizes runtime performance.
    Default = 0,
    ///An optimization option for the Metal compiler that prioritizes minimizing the size of its output binaries, which may also reduce compile time.
    Size = 1
}

enum MTLLibraryType : NSInteger
{
    ///A library that can create pipeline state objects.
    Executable = 0,
    ///A library that you can dynamically link to from other libraries.
    Dynamic = 1
}


class MTLCompileOptions : NSObject
{
    mixin ObjcExtend;
    @selector("alloc")
    static MTLCompileOptions alloc();

    @selector("init")
    override MTLCompileOptions initialize();

    alias ini = initialize;

    ///A Boolean value that indicates whether the compiler can perform optimizations for floating-point arithmetic that may violate the IEEE 754 standard.
    @selector("fastMathEnabled")
    BOOL fastMathEnabled();
    @selector("setFastMathEnabled:")
    BOOL fastMathEnabled(BOOL);

    ///A Boolean value that indicates whether the compiler should compile vertex shaders conservatively to generate consistent position calculations.
    @selector("preserveInvariance")
    BOOL preserveInvariance();
    @selector("setPreserveInvariance:")
    BOOL preserveInvariance(BOOL);

    ///The language version used to interpret the library source code.
    @selector("languageVersion")
    MTLLanguageVersion languageVersion();
    @selector("setLanguageVersion:")
    MTLLanguageVersion languageVersion(MTLLanguageVersion);

    ///A list of preprocessor macros to apply when compiling the library source.
    @selector("preprocessorMacros")
    NSDictionary preprocessorMacros();
    @selector("setPreprocessorMacros:")
    NSDictionary preprocessorMacros(NSDictionary);

    ///An option that tells the compiler what to prioritize when it compiles Metal shader code.
    @selector("optimizationLevel")
    MTLLibraryOptimizationLevel optimizationLevel();
    @selector("setOptimizationLevel:")
    MTLLibraryOptimizationLevel optimizationLevel(MTLLibraryOptimizationLevel);

    ///An array of dynamic libraries the Metal compiler links against.
    @selector("libraries")
    NSArray libraries();
    @selector("setLibraries:")
    NSArray libraries(NSArray);

    ///The kind of library to create.
    @selector("libraryType")
    MTLLibraryType libraryType();
    @selector("setLibraryType:")
    MTLLibraryType libraryType(MTLLibraryType);

    ///For a dynamic library, the name to use when installing the library.
    @selector("installName")
    NSString installName();
    @selector("setInstallName:")
    NSString installName(NSString);
}

interface MTLLibrary
{
    ///The installation name for a dynamic library.
    @selector("installName")
    NSString installName();
    ///The library’s basic type.
    @selector("type")
    MTLLibraryType type();

    @selector("functionNames")
    NSArray_!NSString _functionNames();
    ///The names of all public functions in the library.
    extern(D) final NSArrayD!NSString functionNames()
    {
        return NSArrayD!(NSString)(_functionNames);
    }

    @selector("newFunctionWithName:")
    MTLFunction newFunctionWithName(NSString);
}