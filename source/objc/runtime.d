module objc.runtime;

version(D_ObjectiveC):

NSString ns(string str)
{
    import core.memory;
    str~= '\0';
    // scope(exit) GC.free(cast(void*)str.ptr);
    return NSString.alloc.initWithUTF8String(str.ptr);
}


extern(Objective-C):


public import core.attribute:selector;
alias BOOL = bool;
enum YES = true;
enum NO = false;

///Type used to represent elapsed time in seconds.
alias CFTimeInterval = double;

version(watchOS)
{
    alias NSUInteger = uint;
    alias NSInteger = int;
} 
else
{
    alias NSInteger = long;
    alias NSUInteger = ulong;
}
extern class NSObject
{
    static NSObject alloc() @selector("alloc");
    NSObject initialize() @selector("init");
    ///Increments the receiver’s reference count.
    NSObject retain() @selector("retain");
    ///Allocates a new instance of the receiving class, sends it an init message, and returns the initialized object.
    NSObject new_() @selector("new");
    ///Decrements the receiver’s reference count.
    void release() @selector("release");
    ///Deallocates the memory occupied by the receiver.
    void dealloc() @selector("dealloc");
    ///Decrements the receiver’s retain count at the end of the current autorelease pool block.
    NSObject autorelease() @selector("autorelease");

}

/** 
 * Used for NSObjects. It will define a new
 *  alloc, init and an opCall for that.
 */
mixin template ObjectiveCOpCall()
{
    extern(Objective-C)
    {
        override static typeof(this) alloc() @selector("alloc");
        override typeof(this) initialize() @selector("init");
    }
    extern(D) final static typeof(this) opCall()
    {
        return alloc.initialize;
    }
}

extern(C) void NSLog(NSString str, ...);


extern(Objective-C)
extern class NSString
{
    static NSString alloc() @selector("alloc");
    NSString initWithUTF8String(in char* str) @selector("initWithUTF8String:");

    @selector("stringWithCString:encoding:")
    static NSString stringWithCString(const(char)* stringWithCString, size_t encoding);

    ///Returns a string created by copying the data from a given C array of UTF8-encoded bytes.
    @selector("stringWithUTF8String:")
    static NSString stringWithUTF8String(const(char)* nullTerminatedCString);

    ///A null-terminated UTF8 representation of the string.
    @selector("UTF8String")
    immutable(char)* UTF8String() @nogc const;


    static size_t defaultCStringEncoding();
    void release() @selector("release");

    extern(D) final string toString() @nogc const
    {
        immutable(char)* ret = UTF8String();
        size_t i = 0; while(ret[i++] != '\0'){}
        if(i > 0) return ret[0..i-1];
        return null;
    }
}

private extern(C) void* _D4objc7runtime7NSArray7__ClassZ = null;
extern class NSArray : NSObject
{
    NSArray init() @selector("init");
    ///Creates and returns an empty array.
    @selector("array")
    static NSArray array();

    ///Creates and returns an array containing the objects in another given array.
    @selector("arrayWithArray:")
    static NSArray array(NSArray array);

    ///Creates and returns an array containing a given object.
    @selector("arrayWithObject:")
    static NSArray array(NSObject object);  

    ///Creates and returns an array containing the objects in the argument list.
    @selector("arrayWithObjects:")
    static NSArray array(NSObject objects, ...);

    ///Creates and returns an array that includes a given number of objects from a given C array.
    @selector("arrayWithObjects:count:")
    static NSArray array(NSObject* objects, NSUInteger count); 

    ///The number of objects in the array.
    @selector("count")
    NSUInteger count();
    alias length = count;

    ///Returns the object located at the specified index.
    @selector("objectAtIndex:")
    NSObject objectAtIndex(NSUInteger index);
}

alias NSArray_(T) = NSArray;

struct NSArrayD(T)
{
    NSArray arr = void;
    alias arr this;

    auto opAssign(NSArray arr)
    {
        this.arr = arr;
        return this;
    }

    extern(D) pragma(inline, true) T opIndex(size_t index)
    {
        return cast(T)cast(void*)arr.objectAtIndex(index);
    }
    extern(D) final int opApply(scope int delegate(T) dg)
    {
        int result = 0;
        NSUInteger l = arr.count;
        for(int i = 0; i < l; i++)
        {
            T item = opIndex(i);
            result = dg(item);
            if (result)
                break;
        }
        return result;
    }
}

extern class NSDictionary : NSObject
{
    static NSDictionary dictionary();
}

alias NSErrorDomain = NSString;

extern class NSError
{
    ///The error code
    @selector("code")
    NSInteger code();

    ///A string containing the error domain.
    @selector("domain")
    NSErrorDomain domain();


    ///A string containing the localized description of the error.
    @selector("localizedDescription")
    NSString localizedDescription();

    ///An array containing the localized titles of buttons appropriate for displaying in an alert panel.
    @selector("localizedRecoveryOptions")
    NSArray_!NSString _localizedRecoveryOptions();

    extern(D) final NSArrayD!NSString localizedRecoveryOptions()
    {
        return NSArrayD!NSString(_localizedRecoveryOptions);
    }

    ///A string containing the localized recovery suggestion for the error.
    @selector("localizedRecoverySuggestion")
    NSString localizedRecoverySuggestion();

    ///A string containing the localized explanation of the reason for the error.
    @selector("localizedFailureReason")
    NSString localizedFailureReason();


    extern(D) final void print()
    {
        NSLog("Objective-C Error: %@".ns, this);
    }
}
struct NSRange
{
    NSUInteger length;
    NSUInteger location;
}
extern class NSData : NSObject{}