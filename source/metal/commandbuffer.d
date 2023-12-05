module metal.commandbuffer;
import objc.meta : selector, ObjcExtend;
import metal.metal;
import metal.rendercommandencoder;
import metal.blitcommandencoder;

@ObjectiveC final extern(C++):

///Options for reporting errors from a command buffer.
enum MTLCommandBufferErrorOption : NSUInteger
{
    ///An option that clears a command buffer’s error options.
    None = 0,
    ///An option that instructs a command buffer to save additional details about a GPU runtime error.
    EncoderExecutionStatus = 1 << 0
}

///A configuration that customizes the behavior for a new command buffer.
class MTLCommandBufferDescriptor
{
    mixin ObjcExtend!NSObject;
    @selector("alloc")
    static MTLCommandBufferDescriptor alloc();

    @selector("init")
    MTLCommandBufferDescriptor initialize(); 

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

///Error codes that indicate why a command buffer is unable to finish its execution.
enum MTLCommandBufferError : NSUInteger
{
    ///An error code that represents the absence of any problems.
    None = 0,
    ///An error code that indicates the system interrupted and terminated the command buffer because it took more time to execute than the system allows.
    Timeout = 2,
    ///An error code that indicates the command buffer generated a page fault the GPU can’t service.
    PageFault = 3,
    ///An error code that indicates a process doesn’t have access to a GPU device.
    NotPermitted = 7,
    ///An error code that indicates the GPU device doesn’t have sufficient memory to execute a command buffer.
    OutOfMemory = 8,
    ///An error code that indicates the command buffer has an invalid reference to resource.
    InvalidResource = 9,
    ///An error code that indicates the GPU ran out of one or more of its internal resources that support memoryless render pass attachments.
    Memoryless = 10,
    ///An error code that indicates a person physically removed the GPU device before the command buffer finished running.
    DeviceRemoved = 11,
    ///An error code that indicates the GPU terminated the command buffer because a kernel function of tile shader used too many stack frames.
    StackOverflow = 12,
    ///An error code that indicates the system has revoked the Metal device’s access because it’s responsible for too many timeouts or hangs.
    AccessRevoked = 4,
    ///An error code that indicates the Metal framework has an internal problem.
    ErrorInternal = 1

}

///A configuration you create to customize a blit command encoder, which affects the runtime behavior of the blit pass you encode with it.
class MTLBlitPassDescriptor
{
    mixin ObjcExtend!NSObject;
    ///Creates a new blit pass descriptor with a default configuration.
    @selector("blitPassDescriptor")
    static MTLBlitPassDescriptor blitPassDescriptor();

    ///An array of counter sample buffer attachments that you configure for a blit pass.

}

///A completion handler signature a GPU device calls when it finishes scheduling a command buffer, or when the GPU finishes running it.
alias MTLCommandBufferHandler = extern(C) void function(MTLCommandBuffer);



///Possible error conditions for the command encoder’s commands.
enum MTLCommandEncoderErrorState : NSInteger
{
    ///A state that indicates the GPU successfully executed the commands without any errors.
    Completed = 1, 
    ///An error state that indicates the GPU didn’t execute the commands.
    Pending = 3,
    ///An error state that indicates the GPU failed to fully execute the commands because of an error.
    Affected = 2,
    ///An error state that indicates the commands in the command buffer are the cause of an error.
    Faulted = 4,
    ///An error state that indicates the command buffer doesn’t know the state of its commands on the GPU.
    Unknown = 0
}


///A container that provides additional information about a runtime failure a GPU encounters as it runs the commands in a command buffer.
interface MTLCommandBufferEncoderInfo
{
    ///The name of the encoder that generates the error information
    @selector("label")
    NSString label();

    ///An array of debug signposts that Metal records as the GPU executes the commands of the encoder’s pass.
    @selector("debugSignposts")
    NSArray_!NSString debugSignposts();

    ///The execution status of the command encoder.
    @selector("errorState")
    MTLCommandEncoderErrorState errorState();



}

///Options for different kinds of function logs.
enum MTLFunctionLogType : NSUInteger
{
    ///A message related to usage validation.
    Validation = 0
}


///The source code that logged a debug message.
interface MTLFunctionLogDebugLocation
{
    ///The name of the shader function.
    @selector("functionName")
    NSString functionName();

    ///The URL of the file that contains the shader function.
    @selector("URL")
    NSURL URL();
    
    ///The line that the log message appears on.
    @selector("line")
    NSUInteger line();
    
    ///The column where the log message appears.
    @selector("column")
    NSUInteger column();
}


///A log entry a Metal device generates when the it runs a command buffer.
interface MTLFunctionLog
{
    ///The type of message that was logged.
    @selector("type")
    MTLFunctionLogType type();
    
    ///If known, the location of the logging command within a shader source file.
    @selector("debugLocation")
    MTLFunctionLogDebugLocation debugLocation();
    
    ///The label for the encoder that logged the message.
    @selector("encoderLabel")
    NSString encoderLabel();
    
    ///When known, the function object corresponding to the logged message.
    @selector("function")
    MTLFunction function_();
}

///A collection of logged messages, created when a Metal device runs a command buffer.
interface MTLLogContainer
{
    mixin ObjcExtend!NSFastEnumeration;
}

///A container that stores a sequence of GPU commands that you encode into it.
interface MTLCommandBuffer
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

    ///Creates a block information transfer (blit) encoder.
    @selector("blitCommandEncoder")
    MTLBlitCommandEncoder blitCommandEncoder();

    ///Creates a block information transfer (blit) encoder from a descriptor.
    @selector("blitCommandEncoderWithDescriptor:")
    MTLBlitCommandEncoder blitCommandEncoderWithDescriptor(MTLBlitPassDescriptor);


    ///A string to help identify this object
    @selector("label")
    NSString label();
    @selector("setLabel:")
    NSString label(NSString);


    ///The command queue that creates the command buffer.
    @selector("commandQueue")
    MTLCommandQueue commandQueue();
    @selector("setCommandQueue:")
    MTLCommandQueue commandQueue(MTLCommandQueue);

    ///Marks the beginning of a debug group and gives it an identifying label, which temporarily replaces the previous group, if applicable.
    @selector("pushDebugGroup")
    void pushDebugGroup(NSString);


    ///Marks the end of a debug group and, if applicable, restores the previous group from a stack.
    @selector("popDebugGroup")
    void popDebugGroup();


    ///A description of an error when the GPU encounters an issue as it runs the command buffer.
    @selector("error")
    NSError error();
    @selector("setError:")
    NSError error(NSError);

    /// Settings that determine which information the command buffer records about execution errors, and how it does it.
    @selector("errorOptions")
    MTLCommandBufferErrorOption errorOptions();
    @selector("setErrorOptions:")
    MTLCommandBufferErrorOption errorOptions(MTLCommandBufferErrorOption);

    ///The messages the command buffer records as the GPU runs its commands.

    @selector("logs")
    MTLLogContainer logs();


    ///The host time, in seconds, when the CPU begins to schedule the command buffer.
    @selector("kernelStartTime")
    CFTimeInterval kernelStartTime();

    ///The host time, in seconds, when the CPU finishes scheduling the command buffer.
    @selector("kernelEndTime")
    CFTimeInterval kernelEndTime();

    ///The host time, in seconds, when the GPU starts command buffer execution.
    @selector("GPUStartTime")
    CFTimeInterval GPUStartTime();

    ///The host time, in seconds, when the GPU finishes execution of the command buffer.
    @selector("GPUEndTime")
    CFTimeInterval GPUEndTime();

}