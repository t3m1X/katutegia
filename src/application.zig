const UpdateState = @import("utils.zig").UpdateState;

pub fn init() bool {
    // TODO: Init the modules
    return true;
}

pub fn Update() UpdateState {
    // TODO: Call pre ~ and post-update
    return UpdateState.stop;
}

pub fn cleanUp() bool {
    // TODO: Add CleanUp logic of modules
    return true;
}
