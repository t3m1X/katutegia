const std = @import("std");
const app = @import("application.zig");
const utils = @import("utils.zig");

pub fn main() !void {
    const main_states = enum { MAIN_START, MAIN_UPDATE, MAIN_FINISH, MAIN_EXIT };
    var state = main_states.MAIN_START;

    while (state != main_states.MAIN_EXIT) {
        switch (state) {
            main_states.MAIN_START => {
                if (app.Init()) {
                    state = main_states.MAIN_UPDATE;
                } else {
                    // TODO: Throw an error
                    state = main_states.MAIN_EXIT;
                }
            },

            main_states.MAIN_UPDATE => {
                var update_return: utils.update_state = app.Update();
                if (update_return == utils.update_state.UPDATE_ERROR) {
                    state = main_states.MAIN_EXIT;
                } else if (update_return == utils.update_state.UPDATE_STOP)
                    state = main_states.MAIN_FINISH;
                state = main_states.MAIN_FINISH;
            },

            main_states.MAIN_FINISH => {
                // TODO: Add CleanUp logic
                // For now we go to MAIN_EXIT
                state = main_states.MAIN_EXIT;
            },

            else => {
                state = main_states.MAIN_EXIT;
            },
        }
    }
}
