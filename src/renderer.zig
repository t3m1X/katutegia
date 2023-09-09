const c = @import("c.zig");
const window = @import("window.zig");
const UpdateState = @import("utils.zig").UpdateState;

var camera = c.SDL_Rect{
    .x = 0,
    .y = 0,
    .w = 0,
    .h = 0,
};
var scale = 1;
var renderer: ?*c.SDL_Renderer = null;

pub fn init() !void {
    var flags: u32 = c.SDL_RENDERER_PRESENTVSYNC;
    renderer = c.SDL_CreateRenderer(window.window, -1, flags);

    c.SDL_GetWindowSize(window.window, camera.w, camera.h);

    if (renderer == null) {
        c.SDL_Log("Renderer could not be created! SDL_Error: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    }
}

pub fn cleanUp() !void {
    if (renderer != null)
        c.SDL_DestroyRenderer(renderer);
}

pub fn PreUpdate() UpdateState {
    if (c.SDL_RenderClear(renderer) != 0) {
        c.SDL_Log("Renderer could not be cleared! SDL_Error: %s", c.SDL_GetError());
        return .fail;
    }
    return .success;
}

pub fn PostUpdate() UpdateState {
    c.SDL_RenderPresent(renderer);
    return .success;
}

fn blit(texture: *const c.SDL_Texture, x: u8, y: u8, section: ?*const c.SDL_Rect, size: f16) !void {
    var rect = c.SDL_Rect{
        .x = camera.x + x * scale,
        .y = camera.y + y * scale,
        .w = 0,
        .h = 0,
    };

    if (section) {
        rect.w = section.w * size;
        rect.h = section.h * size;
    } else {
        c.SDL_QueryTexture(texture, null, null, &rect.w, &rect.h);
        rect.w *= size;
        rect.h *= size;
    }

    if (c.SDL_RenderCopy(renderer, texture, section, &rect) != 0) {
        c.SDL_Log("Cannot blit to screen. SDL_RenderCopy error: %s", c.SDL_GetError());
        return error.SDLRender;
    }
}
