const std = @import("std");
const ArrayList = std.ArrayList;

pub fn main() !void {
    var file = try std.fs.cwd().openFile("./2/input", .{});
    defer file.close();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var list = ArrayList(i32).init(allocator);
    defer list.deinit();

    var safeCount: u32 = 0;
    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        list.clearRetainingCapacity();
        var it = std.mem.split(u8, line, " ");
        while (it.next()) |token| {
            try list.append(try std.fmt.parseInt(i32, token, 10));
        }

        var ignoreIndex: usize = 0;
        while (ignoreIndex < list.items.len) {
            if (isSafe(list, ignoreIndex)) {
                safeCount += 1;
                break;
            }
            ignoreIndex += 1;
        }
    }
    std.debug.print("Safe count: {}\n", .{safeCount});
}

fn isSafe(list: ArrayList(i32), ignoreIndex: usize) bool {
    var direction: i8 = 0;
    var lastNumber: i32 = -1;
    var safe = true;

    for (list.items, 0..) |currentNumber, index| {
        if (index == ignoreIndex) {
            continue;
        }
        if (lastNumber == -1) {
            lastNumber = currentNumber;
            continue;
        }
        if (@abs(currentNumber - lastNumber) > 3) {
            safe = false;
            break;
        }
        if (currentNumber == lastNumber) {
            safe = false;
            break;
        }
        if (direction == 0 and lastNumber != -1) {
            if (currentNumber > lastNumber) {
                direction = 1;
            } else if (currentNumber < lastNumber) {
                direction = -1;
            }
            lastNumber = @intCast(currentNumber);
            continue;
        }
        if (direction == 1 and currentNumber < lastNumber) {
            safe = false;
            break;
        }
        if (direction == -1 and currentNumber > lastNumber) {
            safe = false;
            break;
        }
        lastNumber = @intCast(currentNumber);
    }
    return safe;
}
