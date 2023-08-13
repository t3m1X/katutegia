const c = @import("c.zig");

pub var window: ?*c.SDL_Window = null;
pub var surface: ?*c.SDL_Surface = null;

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

    surface = c.SDL_GetWindowSurface(window);
}

pub fn cleanUp() !void {
    if (window != null)
        c.SDL_DestroyWindow(window);

    surface = null;
    window = null;

    c.SDL_Quit();
}
