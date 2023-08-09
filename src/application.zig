const UpdateState = @import("utils.zig").UpdateState;
const window = @import("window.zig");

pub fn init() !void {
    // TODO: Init the modules
    try window.init();
}

pub fn Update() UpdateState {
    // TODO: Call pre ~ and post-update
    return .stop;
}

pub fn cleanUp() !void {
    // TODO: Add CleanUp logic of modules
    try window.cleanUp();
}
