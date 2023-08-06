const UpdateState = @import("utils.zig").UpdateState;

pub fn Init() bool {
    // TODO: Init the modules
    return true;
}

pub fn Update() UpdateState {
    // TODO: Call pre ~ and post-update
    return UpdateState.UPDATE_STOP;
}

pub fn CleanUp() bool {
    // TODO: Add CleanUp logic of modules
    return true;
}
