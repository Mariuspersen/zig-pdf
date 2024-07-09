const std = @import("std");
const pdf = @import("pdf");

const fs = std.fs;
const mem = std.mem;
const compress = std.compress;
const testing = std.testing;

test "Print PDF Content" {
    const file = try fs.cwd().openFile("pdf.pdf", .{});
    const stat = try file.stat();
    const data = try file.readToEndAlloc(testing.allocator, stat.size);

    defer file.close();
    defer testing.allocator.free(data);

    var index: usize = 0;

    while (mem.indexOf(u8, data[index..], "stream")) |start| {
        defer index = start;

        if(mem.indexOf(u8, data[index..], "endstream")) |end| {
            var compressed = std.io.fixedBufferStream(data[start+7..end-1]);
            var uncompressed = std.ArrayList(u8).init(testing.allocator);
            defer uncompressed.deinit();

            try compress.zlib.decompress(compressed.reader(), uncompressed.writer());
            std.debug.print("{s}\n", .{uncompressed.items});

        } else break;
    }

}