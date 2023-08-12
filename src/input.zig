const c = @import("c.zig");
const UpdateState = @import("utils.zig").UpdateState;

const max_keys = 300;
var keyboard: [max_keys]KeyState = undefined;
pub const KeyState = enum(u8) { idle = 0, down, repeat, up };

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
    c.SDL_PumpEvents();
    const keys = c.SDL_GetKeyboardState(0);

    for (0..max_keys) |i| {
        if (keys[i] == 1) {
            if (keyboard[i] == .idle) {
                keyboard[i] = .down;
            } else keyboard[i] = .repeat;
        } else {
            if (keyboard[i] == .repeat or keyboard[i] == .down) {
                keyboard[i] = .up;
            } else keyboard[i] = .idle;
        }
    }

    // TODO: This is a temporal exit
    if (@intFromEnum(keyboard[c.SDL_SCANCODE_ESCAPE]) != 0) //SCANCODE = 41
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
