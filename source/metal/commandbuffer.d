module metal.commandbuffer;

version(D_ObjectiveC):
extern(Objective-C):

import metal.metal;
import metal.rendercommandencoder;

///Options for reporting errors from a command buffer.
enum MTLCommandBufferErrorOption : NSUInteger
{
    ///An option that clears a command buffer’s error options.
    None = 0,
    ///An option that instructs a command buffer to save additional details about a GPU runtime error.
    EncoderExecutionStatus = 1 << 0
}

///A configuration that customizes the behavior for a new command buffer.
extern class MTLCommandBufferDescriptor : NSObject
{
    ///A Boolean value that indicates whether the command buffer the descriptor creates maintains strong references to the resources it uses.
    @selector("retainedResources")
    BOOL retainedResources();
    @selector("setRetainedResources:")
    BOOL retainedResources(BOOL);

    ///The reporting configuration that indicates which information the GPU driver stores in a command buffer’s error property.
    @selector("errorOptions")
    MTLCommandBufferErrorOption errorOptions();

    @selector("setErrorOptions:")
    MTLCommandBufferErrorOption errorOptions(MTLCommandBufferErrorOption);
}

///The discrete states for a command buffer that represent its life cycle stages.
enum MTLCommandBufferStatus : NSUInteger
{
    ///A command buffer’s initial state, which indicates its command queue isn’t reserving a place for it.
    NotEnqueued = 0,
    ///A command buffer’s second state, which indicates its command queue is reserving a place for it.
    Enqueued = 1,
    ///A command buffer’s third state, which indicates the command queue is preparing to schedule the command buffer by resolving its dependencies.
    Committed = 2,
    ///A command buffer’s fourth state, which indicates the command buffer has its resources ready and is waiting for the GPU to run its commands.
    Scheduled = 3,
    ///A command buffer’s successful, final state, which indicates the GPU finished running the command buffer’s commands without any problems.
    Completed = 4,
    ///A command buffer’s unsuccessful, final state, which indicates the GPU stopped running the buffer’s commands because of a runtime issue.
    Error = 5
}

///A completion handler signature a GPU device calls when it finishes scheduling a command buffer, or when the GPU finishes running it.
alias MTLCommandBufferHandler = extern(C) void function(MTLCommandBuffer);

///A container that stores a sequence of GPU commands that you encode into it.
extern interface MTLCommandBuffer
{
    ///Encodes a command into the command buffer that pauses the GPU from running subsequent passes until the event equals or exceeds a value.
    @selector("encodeWaitForEvent:value:")
    void encodeWaitForEvent(MTLEvent event, ulong value);

    ///Encodes a command into the command buffer that pauses the GPU from running subsequent passes until the event equals or exceeds a value.
    @selector("encodeSignalEvent:value:")
    void encodeSignalEvent(MTLEvent event, ulong value);

    ///Presents a drawable as early as possible.
    @selector("presentDrawable:")
    void presentDrawable(MTLDrawable drawable);

    ///Presents a drawable at a specific time.
    @selector("presentDrawable:atTime:")
    void presentDrawable(MTLDrawable drawable, CFTimeInterval presentationTime);

    ///Presents a drawable after the system presents the previous drawable for an amount of time.
    @selector("presentDrawable:afterMinimumDuration:")
    void presentDrawableAfterMinimumDuration(MTLDrawable drawable, CFTimeInterval duration);

    ///Registers a completion handler the GPU device calls immediately after it schedules the command buffer to run on the GPU.
    @selector("addScheduleHandler:")
    void addScheduleHandler(MTLCommandBufferHandler);

    ///Registers a completion handler the GPU device calls immediately after the GPU finishes running the commands in the command buffer.
    @selector("addCompletedHandler:")
    void addCompletedHandler(MTLCommandBufferHandler);
    
    ///Reserves the next available place for the command buffer in its command queue.
    @selector("enqueue")
    void enqueue();

    ///Submits the command buffer to run on the GPU.
    @selector("commit")
    void commit();

    ///Synchronously waits for the command queue to schedule the buffer, which can block the current thread’s execution.
    @selector("waitUntilScheduled")
    void waitUntilScheduled();

    ///Synchronously waits for the GPU to finish running the command buffer, which can block the current thread’s execution.
    @selector("waitUntilCompleted")
    void waitUntilCompleted();

    ///The command buffer’s current state.
    @selector("status")
    MTLCommandBufferStatus status();

    @selector("renderCommandEncoderWithDescriptor:")
    MTLRenderCommandEncoder renderCommandEncoderWithDescriptor(MTLRenderPassDescriptor renderPassDescriptor);

    ///A string to help identify this object
    @selector("label")
    NSString label();
    @selector("setLabel:")
    NSString label(NSString);
}