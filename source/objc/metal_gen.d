module objc.metal_gen;
import objc.meta;

import objc.runtime,
       metal.blitcommandencoder,
       metal.commandbuffer,
       metal.library,
       metal.metal,
       metal.metalkit,
       metal.rendercommandencoder,
       metal.texture,
       metal.vertexdescriptor;


mixin ObjcLinkModule!(objc.runtime);
mixin ObjcLinkModule!(metal.blitcommandencoder);
mixin ObjcLinkModule!(metal.commandbuffer);
mixin ObjcLinkModule!(metal.library);
mixin ObjcLinkModule!(metal.metal);
mixin ObjcLinkModule!(metal.metalkit);
mixin ObjcLinkModule!(metal.rendercommandencoder);
mixin ObjcLinkModule!(metal.texture);
mixin ObjcLinkModule!(metal.vertexdescriptor);