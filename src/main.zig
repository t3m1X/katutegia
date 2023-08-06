const std = @import("std");
const app = @import("application.zig");
const UpdateState = @import("utils.zig").UpdateState;

pub fn main() !u8 {
    const MainStates = enum { MAIN_START, MAIN_UPDATE, MAIN_FINISH, MAIN_EXIT };
    const MainReturn = enum(u8) { RETURN_SUCCESS = 0, RETURN_FAILURE };
    var state = MainStates.MAIN_START;
    var main_return: u8 = MainReturn.RETURN_FAILURE;

    while (state != MainStates.MAIN_EXIT) {
        switch (state) {
            MainStates.MAIN_START => {
                if (app.Init()) {
                    state = MainStates.MAIN_UPDATE;
                } else {
                    // TODO: Throw an error
                    state = MainStates.MAIN_EXIT;
                }
            },

            MainStates.MAIN_UPDATE => {
                var update_return: UpdateState = app.Update();
                if (update_return == UpdateState.UPDATE_ERROR) {
                    state = MainStates.MAIN_EXIT;
                } else if (update_return == UpdateState.UPDATE_STOP)
                    state = MainStates.MAIN_FINISH;
            },

            MainStates.MAIN_FINISH => {
                if (app.CleanUp()) {
                    main_return = MainReturn.RETURN_SUCCESS;
                } else {
                    // TODO: Throw an error
                }
                state = MainStates.MAIN_EXIT;
            },

            else => {
                state = MainStates.MAIN_EXIT;
            },
        }
    }

    return main_return;
}
