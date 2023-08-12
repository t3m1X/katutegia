const c = @import("c.zig");
var window: ?*c.SDL_Window = null;

pub fn init() !void {
    if (c.SDL_Init(c.SDL_INIT_VIDEO) != 0) {
        c.SDL_Log("Unable to initialize SDL: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    }

    // TODO: These need to not be hardcoded
    const width = 758;
    const height = 660;
    const flags = c.SDL_WINDOW_SHOWN | c.SDL_WINDOW_RESIZABLE;

    window = c.SDL_CreateWindow("Katutegia", c.SDL_WINDOWPOS_UNDEFINED, c.SDL_WINDOWPOS_UNDEFINED, width, height, flags);

    if (window == null) {
        c.SDL_Log("Window could not be initialized: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    }
}

pub fn cleanUp() !void {
    if (window != null)
        c.SDL_DestroyWindow(window);

    c.SDL_Quit();
}
