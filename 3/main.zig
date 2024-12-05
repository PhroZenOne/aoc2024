const std = @import("std");
const ArrayList = std.ArrayList;

pub fn main() !void {
    var file = try std.fs.cwd().openFile("./3/input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    const multiply_pattern: []const u8 = "mul(";
    const do_pattern: []const u8 = "do()";
    const dont_pattern: []const u8 = "don't()";

    var multiply_pattern_counter: u8 = 0;
    var do_or_dont_pattern_counter: u8 = 0;
    var msg_buf: [4096]u8 = undefined;

    var enabled = true;
    var inX = false;
    var inY = false;
    var intX: u32 = 0;
    var intY: u32 = 0;
    var count: u32 = 0;
    var sum: u32 = 0;
    while (true) {
        const size = try in_stream.read(&msg_buf);
        if (size == 0) {
            break;
        }
        var k: u32 = 0;
        while (k < size) : (k += 1) {
            const current_char = msg_buf[k];
            if (inX) {
                if (current_char >= '0' and current_char <= '9') {
                    intX = intX * 10 + (current_char - '0');
                    if (intX > 999) {
                        inX = false;
                        intX = 0;
                        continue;
                    }
                    continue;
                }
                if (current_char == ',') {
                    inX = false;
                    inY = true;
                    continue;
                }
                // something is wrong
                intX = 0;
                inX = false;
            }
            if (inY) {
                if (current_char >= '0' and current_char <= '9') {
                    intY = intY * 10 + (current_char - '0');
                    if (intY > 999) {
                        inY = false;
                        intY = 0;
                        continue;
                    }
                    continue;
                }
                if (current_char == ')') {
                    inY = false;
                    count += 1;
                    if (enabled) {
                        sum += intX * intY;
                    }
                    std.debug.print("\nenabled{}: mul({}, {})\n", .{ enabled, intX, intY });
                    continue;
                }
                // something is wrong
                intY = 0;
                inY = false;
            }

            if (enabled) {
                if (dont_pattern[do_or_dont_pattern_counter] != current_char) {
                    do_or_dont_pattern_counter = 0;
                } else {
                    do_or_dont_pattern_counter += 1;
                    if (do_or_dont_pattern_counter == dont_pattern.len) {
                        enabled = false;
                        do_or_dont_pattern_counter = 0;
                    }
                }
            } else {
                if (do_pattern[do_or_dont_pattern_counter] != current_char) {
                    do_or_dont_pattern_counter = 0;
                } else {
                    do_or_dont_pattern_counter += 1;
                    if (do_or_dont_pattern_counter == do_pattern.len) {
                        enabled = true;
                        do_or_dont_pattern_counter = 0;
                    }
                }
            }

            if (multiply_pattern[multiply_pattern_counter] != current_char) {
                multiply_pattern_counter = 0;
            } else {
                multiply_pattern_counter += 1;
                if (multiply_pattern_counter == multiply_pattern.len) {
                    inX = true;
                    intX = 0;
                    intY = 0;
                    multiply_pattern_counter = 0;
                }
            }
        }
    }
    std.debug.print("Count: {}\n {}", .{ count, sum });
}
