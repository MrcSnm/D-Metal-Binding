import std.stdio;
import std.exception;
import bindbc.sdl;
import metal;
import metal.metalkit;
import objc.runtime;
import objc.meta;
import inmath;
import inmath.hsv;

// Time managment
ulong prevTime = 0;
ulong time = 0;

void main() {

	// Init SDL2
	auto load = loadSDL();
	enforce(load != SDLSupport.noLibrary, "SDL2 not found!");
	SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS);

	// Create window with Metal layer attached.
	// NOTE: SDL_WINDOW_ALLOW_HIGHDPI should be passed in to make sure the layer size is correct.
	SDL_Window* window = SDL_CreateWindow("SDL Metal Example", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 640, 480, SDL_WINDOW_METAL | SDL_WINDOW_ALLOW_HIGHDPI | SDL_WINDOW_RESIZABLE);
	SDL_MetalView view = SDL_Metal_CreateView(window);
	CAMetalLayer layer = cast(CAMetalLayer)SDL_Metal_GetLayer(view);

	// Create MTLDevice handle
	auto device = MTLCreateSystemDefaultDevice();
	enforce(cast(void*)device !is null, "Could not create metal device");

	// Attach it to the layer, otherwise we can't render anything.
	layer.device = device;
	writeln("Created Metal context on ", device.name, " (", layer.drawableSize.width, ", ", layer.drawableSize.height, ")...");

	// Prepare drawing primitives.
	CAMetalDrawable drawable;
	MTLCommandQueue queue = layer.device.newCommandQueue();
	MTLRenderPassDescriptor pass = MTLRenderPassDescriptor.new_();
	pass.colorAttachments[0].loadAction = MTLLoadAction.Clear;
	pass.colorAttachments[0].storeAction = MTLStoreAction.Store;

	// Event loop
	bool closeRequested = false;
	while(!closeRequested) {

		// Delta time calculation
		prevTime = time;
		time = SDL_GetTicks64();
		float deltaTime = (cast(float)time-cast(float)prevTime)*0.0001;

		// SDL Event loop
		SDL_PumpEvents();
		SDL_Event ev;
		while (SDL_PollEvent(&ev)) {
			switch(ev.type) {

				case SDL_QUIT: 
					closeRequested = true;
					break;

				case SDL_WINDOWEVENT:
					if (ev.window.event == SDL_WINDOWEVENT_SIZE_CHANGED) {

						// NOTE: The event data provided by ev.window.data1/data2 do not take DPI in to account
						// macOS has fractional UI scaling, so to properly handle that we need to use this API.
						int w, h;
						SDL_Metal_GetDrawableSize(window, &w, &h);
						layer.drawableSize = CGSize(w, h);
					}
					break;
				
				default: break;
			}
		}

		// Change clear color by scrolling through RGB
		drawable = layer.nextDrawable();

		auto rgb = hsv2rgb(vec3((sin(cast(float)time*0.0001)+1)*0.5, 1.0, 1.0));
		pass.colorAttachments[0].clearColor = MTLClearColor(rgb.x, rgb.y, rgb.z, 0);
		pass.colorAttachments[0].texture = drawable.texture;
		MTLCommandBuffer cmdBuffer = queue.commandBuffer();

		MTLRenderCommandEncoder encoder = cmdBuffer.renderCommandEncoderWithDescriptor(pass);
		encoder.endEncoding();
		
		cmdBuffer.presentDrawable(drawable);
		cmdBuffer.commit();
	}
}
