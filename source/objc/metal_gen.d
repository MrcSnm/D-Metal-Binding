module objc.metal_gen;
version(D_ObjectiveC):

import objc.meta;
mixin ObjcLinkModule!metal.blitcommandencoder;
mixin ObjcLinkModule!metal.commandbuffer;
mixin ObjcLinkModule!metal.library;
mixin ObjcLinkModule!metal.metal;
mixin ObjcLinkModule!metal.metalkit;
mixin ObjcLinkModule!metal.rendercommandencoder;
mixin ObjcLinkModule!metal.texture;
mixin ObjcLinkModule!metal.vertexdescriptor;