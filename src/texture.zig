const c = @import("c.zig");
const renderer = @import("renderer.zig");

const max_textures = 50;
var textures: [max_textures]?*c.SDL_Texture = undefined;

pub fn init() !void {
    for (0..max_textures) |i| {
        textures[i] = null;
    }

    const flags = c.IMG_INIT_PNG | c.IMG_INIT_JPG;
    const result = c.IMG_Init(flags);

    if ((result & flags) != flags) {
        c.SDL_Log("Could not initialize Image lib. IMG_Init: %s", c.IMG_GetError());
        return error.SDL_Image;
    }
}

pub fn cleanUp() !void {
    for (0..max_textures) |i| {
        c.SDL_DestroyTexture(textures[i].?);
    }
    c.IMG_Quit();
}

// TODO: Consider working with indices instead of returning pointers

pub fn LoadTexture(path: [*]u8) ?*c.SDL_Texture {
    var texture: ?*c.SDL_Texture = null;
    var surface: ?*c.SDL_Surface = c.IMG_Load(path);
    if (surface == null) {
        // TODO: Log error
    } else {
        texture = c.SDL_CreateTextureFromSurface(renderer.renderer, surface);
        if (texture == null) {
            // TODO: Log error
        } else {
            var stored = false;
            for (0..max_textures) |i| {
                if (textures[i] == null) {
                    textures[i] = texture;
                    stored = true;
                    break;
                }
            }
            if (!stored) {
                // TODO: Log error
                c.SDL_FreeTexture(texture);
                texture = null;
            }
        }

        c.SDL_FreeSurface(surface);
    }

    return texture;
}

pub fn unloadTexture(tex: *c.SDL_Texture) bool {
    var found = false;
    defer c.SDL_DestroyTexture(tex);

    for (0..max_textures) |i| {
        if (textures[i] == tex) {
            textures[i] = null;
            found = true;
            break;
        }
    }

    return found;
}
