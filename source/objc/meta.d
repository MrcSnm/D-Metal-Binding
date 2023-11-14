module objc.meta;
import std.traits;
extern(C)
{
    import core.vararg;
    void objc_msgSend(void* instance, const char* msg, ...);
    void objc_msgSend_stret(void* instance, const char* msg, ...);
    void objc_msgSend_fpret(void* instance, const char* msg, ...);
    void objc_msgSendSuper(void* instance, const char* msg, ...);
    void objc_msgSendSuper_stret(void* instance, const char* msg, ...);
    void* objc_getClass(const char* name);
    void* objc_getProtocol(const char* name);
    void* class_getSuperclass(void* Class);
    SEL sel_registerName(const char* name);
}

// private void* superclass(void* self)
// {
//     static SEL s;
//     if(s == null) s = sel_registerName("superclass");
//     alias fn = extern(C) void* function(void*, SEL);
//     return (cast(fn)&objc_msgSend)(self, s);
// }

// objc_super _objcGetSuper(void* self)
// {
//     return objc_super(self, superclass(self));
// }

struct ObjectiveC;
struct selector{string sel;}
alias SEL = void*;
struct Super;
struct objc_super
{
    void* self;
    void* superClass;
}

bool isAlias(T, string member)()
{
    return __traits(identifier, __traits(getMember, T, member)) != member ||
        !(__traits(isSame, T, __traits(parent, __traits(getMember, T, member))));
}
bool isAliasModule(alias T, string member)()
{
    return __traits(identifier, __traits(getMember, T, member)) != member;
}


string _ObjcGetMsgSend(alias Fn, string arg, bool sliceFirst)()
{
    alias RetT = ReturnType!Fn;
    static if(is(RetT == struct))
        enum send = "objc_msgSend_stret";
    else static if(__traits(isFloating, RetT))
        enum send = "objc_msgSend_fpret";
    else
        enum send = "objc_msgSend";
    enum ident = selToIdent(__traits(getAttributes, Fn)[0].sel);
    return "return (cast(fn)&"~send~")("~arg~", "~ident~", __traits(parameters)"~(sliceFirst ? "[1..$]" : "")~");";
}

string _ObjcGetMsgSuperSend(alias Fn, string arg, bool sliceFirst)()
{
    alias RetT = ReturnType!Fn;
    static if(is(RetT == struct))
        enum send = "objc_msgSendSuper_stret";
    else
        enum send = "objc_msgSendSuper";

    enum ident = selToIdent(__traits(getAttributes, Fn)[0].sel);
    return "return (cast(fn)&"~send~")("~arg~", "~ident~", __traits(parameters)"~(sliceFirst ? "[1..$]" : "")~");";
}


mixin template ObjcExtend(Classes...)
{
    import std.traits:ReturnType, Parameters;
    import objc.meta:isAlias, Super;
    
    
    static foreach(Class; Classes) static foreach(mem; __traits(derivedMembers, Class))
    {
        static if(!isAlias!(Class, mem) && !__traits(hasMember, typeof(this), mem))
        {
            static foreach(ov; __traits(getOverloads, Class, mem))
            {
                static if(!__traits(isStaticFunction, ov))
                {
                    final @selector(__traits(getAttributes, ov)[0].sel) @Super
                    mixin("@", Class.stringof, " ReturnType!ov ",mem,"(Parameters!ov);");
                }
            }
        }
    }
}

string selToIdent(string sel)
{
    char[] ret = new char[sel.length+4];
    ret[0..4] = "_SeL";
    foreach(i; 0..sel.length)
    {
        ret[i+4] = (sel[i] == ':' ? '_' : sel[i]);
    }
    return cast(string)ret;
}

enum _metaGensym(string prefix = "_") =
	'"' ~ prefix ~ `" ~ __traits(identifier, {})["__lambda".length .. $]`;


mixin template ObjcLink(Class)
{
    import std.traits;
    import objc.meta;
    mixin("private void* ",Class.stringof,"_;");
    static foreach(mem; __traits(derivedMembers, Class))
    {
        static if(!isAlias!(Class, mem))
        static foreach(ov; __traits(getOverloads, Class, mem))
        {
            static if(__traits(getLinkage, ov) == "C++")
            {
                static if(!is(typeof(mixin(selToIdent(__traits(getAttributes, ov)[0].sel)))))
                {
                    @selector(__traits(getAttributes, ov)[0].sel)
                    mixin("__gshared SEL ",selToIdent(__traits(getAttributes, ov)[0].sel),";");
                }
                static if(hasUDA!(ov, Super))
                {
                    pragma(mangle, ov.mangleof)
                    mixin("auto ",mixin(_metaGensym!()), " (void* self, Parameters!ov)",
                    "{",
                    "alias fn = ReturnType!ov function (objc_super*, SEL, Parameters!ov);",
                    "objc_super superData = objc_super(self, ", __traits(getAttributes, ov)[2].stringof, "_);",
                    _ObjcGetMsgSuperSend!(ov, "&superData", true),
                    "}");
                }
                else static if(__traits(isStaticFunction, ov))
                {
                    pragma(mangle, ov.mangleof)
                    mixin("auto ",mixin(_metaGensym!()), " (Parameters!ov)",
                    "{",
                    "alias fn = ReturnType!ov function (void*, SEL, Parameters!ov);",
                    _ObjcGetMsgSend!(ov, Class.stringof~"_", false),
                    "}");
                }
                else
                {
                    pragma(mangle, ov.mangleof)
                    mixin("auto ",mixin(_metaGensym!()), " (void* self, Parameters!ov)",
                    "{",
                    "alias fn = ReturnType!ov function (void*, SEL, Parameters!ov);",
                    _ObjcGetMsgSend!(ov, "self", true),
                    "}");
                }
            }
        }
    }
}

mixin template ObjcLinkModule(alias _module)
{
    import std.traits;
    static foreach(mem; __traits(allMembers, _module))
    {
        static if(is(__traits(getMember, _module, mem) == class) || is(__traits(getMember, _module, mem) == interface))
        {
            static if(!isAliasModule!(_module, mem))
                mixin ObjcLink!(__traits(getMember, _module, mem));
        }
    }

    static this()
    {
        //Initialize the module.
        static foreach(mem; __traits(allMembers, _module))
        {{
            alias modMem = __traits(getMember, _module, mem);
            static if(is(modMem == class) || is(modMem == interface))
            {
                static if(!isAliasModule!(_module, mem))
                {
                    static if(is(modMem == class) && hasUDA!(modMem, ObjectiveC))
                        mixin(mem,"_ = objc_getClass(mem);");
                    else static if(is(modMem == interface) && hasUDA!(modMem, ObjectiveC))
                        mixin(mem,"_ = objc_getProtocol(mem);");
                }
            }
        }}
    }
}

mixin template ObjcInitSelectors(alias _module)
{
    import std.traits;
    static this()
    {
        static foreach(mem; __traits(allMembers, _module))
        {{
            static if(mem.length > 4 && mem[0..4] == "_SEL")
            {
                __traits(getMember, _module, mem) = sel_registerName(__traits(getAttributes, __traits(getMember, _module, mem))[0].sel);
            }
        }}
    }
}