module metal.metalkit;

import metal.metal;

version(D_ObjectiveC):
extern(Objective-C):


extern class MTKView
{
    ///Creates a render pass descriptor to draw into the current drawable.
    @selector("currentRenderPassDescriptor")
    MTLRenderPassDescriptor currentRenderPassDescriptor();

    ///The drawable to use for the current frame.
    @selector("currentDrawable")
    CAMetalDrawable currentDrawable();
}