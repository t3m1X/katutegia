const c = @import("c.zig");
const UpdateState = @import("utils.zig").UpdateState;

const max_keys = 300;
pub const KeyState = enum(u8) { idle = 0, down, repeat, up };
pub var keyboard: [max_keys]u8 = undefined;

pub fn init() !void {
    for (0..max_keys) |i| {
        keyboard[i] = @intFromEnum(KeyState.idle);
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
            if (keyboard[i] == @intFromEnum(KeyState.idle)) {
                keyboard[i] = @intFromEnum(KeyState.down);
            } else keyboard[i] = @intFromEnum(KeyState.repeat);
        } else {
            if (keyboard[i] == @intFromEnum(KeyState.repeat) or keyboard[i] == @intFromEnum(KeyState.down)) {
                keyboard[i] = @intFromEnum(KeyState.up);
            } else keyboard[i] = @intFromEnum(KeyState.idle);
        }
    }

    // TODO: This is a temporal exit
    if (keyboard[41] != 0)
        return .stop;

    return .success;
}
