const c = @import("c.zig");
const std = @import("std");
const queue = @import("queue.zig");
const UpdateState = @import("utils.zig").UpdateState;

const max_keys = 300;
var keyboard: [max_keys]KeyState = undefined;
pub const KeyState = enum(u8) { idle = 0, down, repeat, up };

var buffer: [max_keys]u8 = undefined;
var fba = std.heap.FixedBufferAllocator.init(&buffer);
const allocator = fba.allocator();

var up_queue = queue.Queue(u8).init(allocator);

pub fn init() !void {
    for (&keyboard) |*key| {
        key.* = .idle;
    }

    if (c.SDL_Init(c.SDL_INIT_EVENTS) != 0) {
        c.SDL_Log("Unable to initialize SDL_Events: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    }
}

pub fn cleanUp() !void {
    c.SDL_QuitSubSystem(c.SDL_INIT_EVENTS);
}

pub fn PreUpdate() UpdateState {
    while (up_queue.pop()) |scancode| {
        keyboard[scancode] = .idle;
    }

    var event: c.SDL_Event = undefined;
    while (c.SDL_PollEvent(&event) == 1) {
        switch (event.type) {
            c.SDL_QUIT => {
                return .stop;
            },
            c.SDL_KEYDOWN => {
                if (event.key.repeat == 0) {
                    keyboard[event.key.keysym.scancode] = .down;
                } else keyboard[event.key.keysym.scancode] = .repeat;
            },
            c.SDL_KEYUP => {
                keyboard[event.key.keysym.scancode] = .up;
                up_queue.push(@intCast(event.key.keysym.scancode)) catch {}; // We ignore allocation error
            },
            else => {},
        }
    }

    // TODO: This is a temporal exit
    if (keyboard[c.SDL_SCANCODE_ESCAPE] != idle) //SCANCODE = 41
        return .stop;

    return .success;
}

pub fn GetKey(key: u8) !KeyState {
    if (key >= max_keys)
        return error.WrongKey;
    return keyboard[key];
}

// Quick utilities
pub fn isKeyDown(key: u8) bool {
    if (key >= max_keys)
        return false;
    return keyboard[key] == .down;
}

pub fn isKeyUp(key: u8) bool {
    if (key >= max_keys)
        return false;
    return keyboard[key] == .up;
}

pub fn isKeyPressed(key: u8) bool {
    if (key >= max_keys)
        return false;
    return keyboard[key] == .down or keyboard[key] == .repeat;
}
