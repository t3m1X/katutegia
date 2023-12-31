const app = @import("application.zig");
const UpdateState = @import("utils.zig").UpdateState;

pub fn main() !u8 {
    const MainStates = enum { start, update, finish, exit };
    const MainReturn = enum(u8) { success = 0, failure };
    var state = MainStates.start;
    var main_return = MainReturn.failure;

    while (state != MainStates.exit) {
        switch (state) {
            .start => {
                if (app.init()) {
                    state = .update;
                } else |_| {
                    // TODO: Throw an error
                    state = .exit;
                }
            },

            .update => {
                const update_return: UpdateState = app.Update();
                if (update_return == .fail) {
                    state = .exit;
                } else if (update_return == .stop)
                    state = .finish;
            },

            .finish => {
                if (app.cleanUp()) {
                    main_return = .success;
                } else |_| {
                    // TODO: Throw an error
                }
                state = .exit;
            },

            else => {
                state = .exit;
            },
        }
    }
    return @intFromEnum(main_return);
}
