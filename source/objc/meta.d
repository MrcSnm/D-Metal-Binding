module objc.meta;
version(D_ObjectiveC):
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
    SEL sel_registerName(const char* name);
}
struct ObjectiveC;
struct selector{string sel;}
alias SEL = void*;


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
    return "return (cast(fn)&"~send~")("~arg~", s, __traits(parameters)"~(sliceFirst ? "[1..$]" : "")~");";
}

string _ObjcGetMsgSuperSend(alias Fn, string arg, bool sliceFirst)()
{
    alias RetT = ReturnType!Fn;
    static if(is(RetT == struct))
        enum send = "objc_msgSendSuper_stret";
    else
        enum send = "objc_msgSendSuper";
    return "return (cast(fn)&"~send~")("~arg~", s, __traits(parameters)"~(sliceFirst ? "[1..$]" : "")~");";
}


mixin template ObjcExtend()
{
    import std.traits:ReturnType, Parameters;
    import objc.meta:isAlias;
    override
    {
        static foreach(mem; __traits(derivedMembers, typeof(super)))
        {
            static if(!isAlias!(typeof(super), mem))
            {
                static foreach(ov; __traits(getOverloads, typeof(super), mem))
                {
                    static if(!__traits(isStaticFunction, ov) && !__traits(isFinalFunction, ov))
                    {
                        @selector(__traits(getAttributes, ov)[0].sel)
                        mixin("ReturnType!ov ",mem,"(Parameters!ov);");
                    }
                }
            }
        }
    }
}

mixin template ObjcLink(Class)
{
    import std.traits;
    import objc.meta;
    mixin("private void* ",Class.stringof,"_;");
    static foreach(mem; __traits(derivedMembers, Class))
    {
        static if(!isAlias!(Class, mem))
        {
            static foreach(ov; __traits(getOverloads, Class, mem))
            {
                static if(!__traits(isFinalFunction, ov))
                {
                    static if(__traits(isOverrideFunction, ov))
                    {
                        mixin("extern(C) auto ",ov.mangleof, " (Parameters!ov)",
                        "{",
                        "alias fn = extern(C) ReturnType!ov function (void*, SEL, ...);",
                        "static SEL s; if(s == null) s = sel_registerName(__traits(getAttributes, ov)[0].sel);",
                        _ObjcGetMsgSuperSend!(ov, Class.stringof~"_", false),
                        "}");
                    }
                    else static if(__traits(isStaticFunction, ov))
                    {
                        mixin("extern(C) auto ",ov.mangleof, " (Parameters!ov)",
                        "{",
                        "alias fn = extern(C) ReturnType!ov function (void*, SEL, ...);",
                        "static SEL s; if(s == null) s = sel_registerName(__traits(getAttributes, ov)[0].sel);",
                        _ObjcGetMsgSend!(ov, Class.stringof~"_", false),
                        "}");
                    }
                    else
                    {
                        mixin("extern(C) auto ",ov.mangleof, " (void* self, Parameters!ov)",
                        "{",
                        "alias fn = extern(C) ReturnType!ov function (void*, SEL, ...);",
                        "static SEL s; if(s == null) s = sel_registerName(__traits(getAttributes, ov)[0].sel);",
                        _ObjcGetMsgSend!(ov, "self", true),
                        "}");
                    }
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