const std = @import("std");
const ArrayList = std.ArrayList;

pub fn main() !void {
    var file = try std.fs.cwd().openFile("./3/input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    const pattern: []const u8 = "mul(";

    var j: u8 = 0;
    var msg_buf: [4096]u8 = undefined;

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
            const c = msg_buf[k];
            if (inX) {
                if (c >= '0' and c <= '9') {
                    intX = intX * 10 + (c - '0');
                    if (intX > 999) {
                        inX = false;
                        intX = 0;
                        continue;
                    }
                    continue;
                }
                if (c == ',') {
                    inX = false;
                    inY = true;
                    continue;
                }
                // something is wrong
                intX = 0;
                inX = false;
            }
            if (inY) {
                if (c >= '0' and c <= '9') {
                    intY = intY * 10 + (c - '0');
                    if (intY > 999) {
                        inY = false;
                        intY = 0;
                        continue;
                    }
                    continue;
                }
                if (c == ')') {
                    inY = false;
                    count += 1;
                    sum += intX * intY;
                    std.debug.print("\nmul({}, {})\n", .{ intX, intY });
                    continue;
                }
                // something is wrong
                intY = 0;
                inY = false;
            }
            if (pattern[j] != c) {
                j = 0;
                continue;
            }
            std.debug.print("{c}", .{c});
            j += 1;
            if (j == 4) {
                inX = true;
                intX = 0;
                intY = 0;
                j = 0;
            }
        }
    }
    std.debug.print("Count: {}\n {}", .{ count, sum });
}
