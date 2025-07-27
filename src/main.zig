const std = @import("std");
const clap = @import("clap");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) {
            std.debug.print("Memory leak detected\n", .{});
        }
    }

    const params = clap.parseParams(allocator, &.{ clap.Param.help() });
    defer clap.freeParams(allocator, params);

    if (params.help) {
        clap.printHelp(std.io.getStdOut().writer());
        return;
    }
}