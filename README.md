# D-Metal-Binding
Bindings for the D language to Apple's Metal Graphics API 

Those bindings were created by hand and includes comments from apple.developer documentations.
If you wish to contrirbute, try to stick to what was done by keeping comments for easier
developer understanding on what is happening. If possible, the binding must be user friendly
as a programming language to learn Metal.

The Binding has a wrapper over it to make development easier. For example, most arrays are
accessed on Objective-C using `objectIndexedAtSubscript`. However, this API is not natural for D.
So, beyond the bindings, this also includes `opIndex` and `opIndexAssign`, making the API
more familiar to Objective-C.

The binding is a little bit different from Objective-C too by giving g `enum` short names. For example
instead of using `MTLPixelFormatR8Unorm`, this enum is accessed by using `MTLPixelFormat.R8Unorm`.
This will make your code shorter and easier to read. Enums that has a number after the prefix
starts with an underline. For example: `MTLTextureType._2D`.

Another detail on this API, using NSArray as the generic type for everything is counter intuitive, so, for
making the API more self descriptive, this binding defines 2 concepts:

1. NSArray_(T): This is an alias that resolves to NSArray. It does not create a type, and it is solely for
documentation on function purposes. It is the type you use for interfacing with Objective-C.

2. NSArrayD(T): This is a structt that wraps a NSArray with `alias arr this`. It is strongly typed for keeping
your code less error prone. It also wraps `opIndex` and `opApply` for being able to use the foreach and index
operators.
