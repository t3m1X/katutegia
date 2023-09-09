const UpdateState = @import("utils.zig").UpdateState;
const window = @import("window.zig");
const input = @import("input.zig");
const renderer = @import("renderer.zig");

const PreUpdateFns = [_]*const fn () UpdateState{ input.PreUpdate, renderer.PreUpdate };
const UpdateFns = [_]*const fn () UpdateState{};
const PostUpdateFns = [_]*const fn () UpdateState{renderer.PostUpdate};

pub fn init() !void {
    // TODO: Init the modules
    try window.init();
    try input.init();
    try renderer.init();
}

pub fn Update() UpdateState {
    var status = UpdateState.success;

    for (PreUpdateFns) |PreUpdateFn| {
        status = PreUpdateFn();
        if (status != .success) return status;
    }

    for (UpdateFns) |UpdateFn| {
        status = UpdateFn();
        if (status != .success) return status;
    }

    for (PostUpdateFns) |PostUpdateFn| {
        status = PostUpdateFn();
        if (status != .success) return status;
    }

    return status;
}

pub fn cleanUp() !void {
    // TODO: Add CleanUp logic of modules

    // NOTE: we call these in reverse order to init
    try renderer.cleanUp();
    try input.cleanUp();
    try window.cleanUp();
}
