const std = @import("std");
const app = @import("application.zig");
const UpdateState = @import("utils.zig").UpdateState;

pub fn main() !u8 {
    const MainStates = enum { start, update, finish, exit };
    const MainReturn = enum(u8) { success = 0, failure };
    var state = MainStates.start;
    var main_return: u8 = MainReturn.failure;

    while (state != MainStates.exit) {
        switch (state) {
            MainStates.start => {
                if (app.init()) {
                    state = MainStates.update;
                } else {
                    // TODO: Throw an error
                    state = MainStates.exit;
                }
            },

            MainStates.update => {
                var update_return: UpdateState = app.Update();
                if (update_return == UpdateState.fail) {
                    state = MainStates.exit;
                } else if (update_return == UpdateState.stop)
                    state = MainStates.finish;
            },

            MainStates.finish => {
                if (app.cleanUp()) {
                    main_return = MainReturn.success;
                } else {
                    // TODO: Throw an error
                }
                state = MainStates.exit;
            },

            else => {
                state = MainStates.exit;
            },
        }
    }

    return main_return;
}
