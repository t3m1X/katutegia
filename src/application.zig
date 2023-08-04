const utils = @import("utils.zig");

pub fn Init() bool {
    // TODO: Init the modules
    return true;
}

pub fn Update() utils.update_state {
    // TODO: Call pre ~ and post-update
    return utils.update_state.UPDATE_STOP;
}
