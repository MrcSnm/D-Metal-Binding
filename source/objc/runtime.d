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
    NSObject retain();
    ///Decrements the receiver’s reference count.
    void release();
    ///Decrements the receiver’s retain count at the end of the current autorelease pool block.
    NSObject autorelease();

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

    static NSString stringWithCString(char* stringWithCString, size_t encoding);
    static size_t defaultCStringEncoding();
    void release() @selector("release");
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

extern class NSError{}
struct NSRange
{
    NSUInteger length;
    NSUInteger location;
}
extern class NSData : NSObject{}