const std = @import("std");
const testing = std.testing;
const Config = @This();
const Allocator = std.mem.Allocator;
const ArenaAllocator = std.heap.ArenaAllocator;

// These are the supported options
const Key = enum {
    /// The terminal emulator to use for
    /// controlling the windows
    /// default: kitty
    terminal,

    /// The window manager to use for switching focus
    /// if the wondow is already open
    /// default: aerospace for macOS
    @"window-manager",
};

const whitespace = " \n";

_arena: ArenaAllocator,

terminal: Terminal = .kitty,
windowManager: WindowManager = .aerospace,

fn init(alloc: Allocator) !Config {
    return .{
        ._arena = ArenaAllocator.init(alloc),
    };
}

fn deinit(self: *Config) void {
    self._arena.deinit();
    self.* = undefined;
}

/// This function loads configs from config file.
/// This will overwrite keys if already exists.
pub fn loadFromFile(self: *Config, file_path: []const u8) !void {
    var file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    // assuming a line of config cannot be more than 1024 bytes
    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var entry = std.mem.splitSequence(u8, line, "=");
        const key = entry.next() orelse continue;
        const value = entry.next() orelse continue;
        const trimmed_key = std.mem.trim(u8, key, whitespace);
        const trimmed_value = std.mem.trim(u8, value, whitespace);

        try self.setKeyValue(trimmed_key, trimmed_value);
    }
}

/// Sets a config key-value pair. 
/// This can be called from different places like config files,
/// command-line flags or environement variables. If the key 
/// is passed in the `Key` enum format, this function would set 
/// the value properly
pub fn setKeyValue(self: *Config, key: []const u8, value: []const u8) !void {
    if (std.meta.stringToEnum(Key, key)) |config_key| {
        switch (config_key) {
            .terminal => {
                if (std.meta.stringToEnum(Terminal, value)) |enum_val| {
                    self.terminal = enum_val;
                }
            },
            .@"window-manager" => {
                if (std.meta.stringToEnum(WindowManager, value)) |enum_val| {
                    self.windowManager = enum_val;
                }
            },
        }
    } else {
        return error.UnknownKey;
    }
}

const Terminal = enum {
    kitty,
    wezterm,
    alacritty,
    ghostty,
};

const WindowManager = enum {
    aerospace,
};

test "initialize with defaults and override specific fields on parse" {
    const allocator = testing.allocator;

    // First config file
    const config1_content =
        \\terminal = wezterm
        \\window-manager = aerospace
    ;
    const file1_path = "test_config1.txt";
    try std.fs.cwd().writeFile(.{ .sub_path = file1_path, .data = config1_content });
    defer std.fs.cwd().deleteFile(file1_path) catch {};

    // Second config file
    const config2_content =
        \\terminal = ghostty
        \\window-manager = aerospace
    ;
    const file2_path = "test_config2.txt";
    try std.fs.cwd().writeFile(.{ .sub_path = file2_path, .data = config2_content });
    defer std.fs.cwd().deleteFile(file2_path) catch {};

    // Initialize Config
    var config = try Config.init(allocator);
    defer config.deinit();

    // Check default values
    try testing.expectEqual(@as(Terminal, .kitty), config.terminal);
    try testing.expectEqual(@as(WindowManager, .aerospace), config.windowManager);

    // Parse first config file
    try config.loadFromFile(file1_path);
    try testing.expectEqual(@as(Terminal, .wezterm), config.terminal);
    try testing.expectEqual(@as(WindowManager, .aerospace), config.windowManager);

    // Parse second config file
    try config.loadFromFile(file2_path);
    try testing.expectEqual(@as(Terminal, .ghostty), config.terminal);
    try testing.expectEqual(@as(WindowManager, .aerospace), config.windowManager);
}
