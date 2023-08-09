const c = @cImport({
    @cInclude("SDL2/SDL.h");
});

var window: ?*c.SDL_Window = null;

pub fn init() !void {
    if (c.SDL_Init(c.SDL_INIT_VIDEO) != 0) {
        c.SDL_Log("Unable to initialize SDL: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    }
}

pub fn cleanUp() !void {
    if (window != null)
        c.SDL_DestroyWindow(window);

    c.SDL_Quit();
}
