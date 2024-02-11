const c = @import("c.zig");
const std = @import("std");
const queue = @import("queue.zig");
const renderer = @import("renderer.zig");

const max_textures = 50;
var textures: [max_textures]?*c.SDL_Texture = undefined;

var buffer: [max_textures]u8 = undefined;
var fba = std.heap.FixedBufferAllocator.init(&buffer);
const allocator = fba.allocator();

var free_textures = queue.Queue(u8).init(allocator);

pub fn init() !void {
    for (0..max_textures) |i| {
        textures[i] = null;
        free_textures.push(i);
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

// Returns -1 on failure
pub fn loadTexture(path: [*]u8) i8 {
    var texture: ?*c.SDL_Texture = null;
    var surface: ?*c.SDL_Surface = c.IMG_Load(path);
    var index: i8 = -1;
    if (surface == null) {
        std.log("SDL failed to create surface: {}\n", .{c.SDL_GetError()});
    } else {
        texture = c.SDL_CreateTextureFromSurface(renderer.renderer, surface);
        if (texture == null) {
            std.log("SDL failed to create texture: {}\n", .{c.SDL_GetError()});
        } else {
            var space = !free_textures.empty();
            if (space) {
                index = free_textures.pop();
                textures[index] = texture;
            } else {
                std.log("Too many textures loaded, freeing new texture.");
                c.SDL_FreeTexture(texture);
            }
        }
        c.SDL_FreeSurface(surface);
    }

    return index;
}

pub fn GetTexture(index: u8) ?*c.SDL_Texture {
    var texture: ?*c.SDL_Texture = null;
    if (index >= 0 and index < max_textures) {
        texture = textures[index];
    }
    return texture;
}

pub fn unloadTexture(index: u8) bool {
    var found = false;

    if (index >= 0 and index < max_textures) {
        var texture = textures[index];
        if (texture) {
            found = true;
            c.SDL_FreeTexture(texture);
            textures[index] = null;
            free_textures.push(index);
        }
    }

    return found;
}
