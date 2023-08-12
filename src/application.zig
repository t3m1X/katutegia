const UpdateState = @import("utils.zig").UpdateState;
const window = @import("window.zig");
const input = @import("input.zig");

pub fn init() !void {
    // TODO: Init the modules
    try window.init();
    try input.init();
}

pub fn Update() UpdateState {
    // TODO: Call pre ~ and post-update
    return input.PreUpdate();
}

pub fn cleanUp() !void {
    // TODO: Add CleanUp logic of modules

    // Note we call these in reverse order to init
    try input.cleanUp();
    try window.cleanUp();
}
