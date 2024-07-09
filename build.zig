const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addModule("pdf",.{
        .root_source_file = b.path("src/pdf.zig"),
        .target = target,
        .optimize = optimize,
    });
    
    const lib_tests = b.addTest(.{
        .root_source_file = b.path("tests/tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    lib_tests.root_module.addImport("pdf", lib);
    const run_lib_unit_tests = b.addRunArtifact(lib_tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_lib_unit_tests.step);
}
