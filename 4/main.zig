const std = @import("std");
const ArrayList = std.ArrayList;

var width: i32 = 0;
var matrix: ArrayList(u8) = undefined;

pub fn main() !void {
    var file = try std.fs.cwd().openFile("./4/input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    matrix = std.ArrayList(u8).init(allocator);

    var msg_buf: [4096]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&msg_buf, '\n')) |line| {
        width = @as(i32, @intCast(line.len));
        try matrix.appendSlice(line);
    }
    var sum: u32 = 0;
    for (matrix.items, 0..) |char, index| {
        if (char != 'X') {
            continue;
        }
        if (at(index, 1, 0) == 'M' and at(index, 2, 0) == 'A' and at(index, 3, 0) == 'S') {
            sum += 1;
        }
        if (at(index, 1, -1) == 'M' and at(index, 2, -2) == 'A' and at(index, 3, -3) == 'S') {
            sum += 1;
        }
        if (at(index, 0, -1) == 'M' and at(index, 0, -2) == 'A' and at(index, 0, -3) == 'S') {
            sum += 1;
        }
        if (at(index, -1, -1) == 'M' and at(index, -2, -2) == 'A' and at(index, -3, -3) == 'S') {
            sum += 1;
        }
        if (at(index, -1, 0) == 'M' and at(index, -2, 0) == 'A' and at(index, -3, 0) == 'S') {
            sum += 1;
        }
        if (at(index, -1, 1) == 'M' and at(index, -2, 2) == 'A' and at(index, -3, 3) == 'S') {
            sum += 1;
        }
        if (at(index, 0, 1) == 'M' and at(index, 0, 2) == 'A' and at(index, 0, 3) == 'S') {
            sum += 1;
        }
        if (at(index, 1, 1) == 'M' and at(index, 2, 2) == 'A' and at(index, 3, 3) == 'S') {
            sum += 1;
        }
    }
    std.debug.print("\n{}\n", .{sum});
}

fn at(index: usize, x: i32, y: i32) ?u8 {
    const rowIndex = @as(i32, @intCast(index % @as(usize, @intCast(width))));
    const indexi32 = @as(i32, @intCast(index));
    if (rowIndex + x >= width or rowIndex + x < 0) {
        return null;
    }
    if (indexi32 + (y * width) > matrix.items.len or indexi32 + (y * width) < 0) {
        return null;
    }
    return matrix.items[@as(usize, @intCast(indexi32 + (y * width) + x))];
}
