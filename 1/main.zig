const std = @import("std");

pub fn main() !void {
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    var file = try std.fs.cwd().openFile("./1/input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var rightArr = std.ArrayList(u32).init(allocator);
    var leftArr = std.ArrayList(u32).init(allocator);

    defer rightArr.deinit();
    defer leftArr.deinit();

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var it = std.mem.split(u8, line, "   ");
        const leftStr = it.next().?;
        const rightStr = it.next().?;
        try leftArr.append(try std.fmt.parseInt(u32, leftStr, 10));
        try rightArr.append(try std.fmt.parseInt(u32, rightStr, 10));
    }

    std.mem.sort(u32, rightArr.items, {}, comptime std.sort.asc(u32));
    std.mem.sort(u32, leftArr.items, {}, comptime std.sort.asc(u32));
    var sum: u32 = 0;
    for (rightArr.items, leftArr.items) |right, left| {
        sum += @abs(@as(i32, @intCast(left)) - @as(i32, @intCast(right)));
    }
    std.debug.print("{d}\n", .{sum});
}
