module metal.metalkit;

import metal.metal;

version(D_ObjectiveC):
extern(Objective-C):


extern class MTKView
{
    ///Creates a render pass descriptor to draw into the current drawable.
    @selector("currentRenderPassDescriptor")
    MTLRenderPassDescriptor currentRenderPassDescriptor();

    ///The view’s frame rectangle, which defines its position and size in its superview’s coordinate system.
    @selector("frame")
    CGRect frame();
    @selector("setFrame:")
    CGRect frame(CGRect);


    ///The drawable to use for the current frame.
    @selector("currentDrawable")
    CAMetalDrawable currentDrawable();

    ///The device object the view uses to create its Metal objects.
    ///Only getter will be supported since the renderer is initialized from Objective-C
    @selector("device")
    MTLDevice device();
}