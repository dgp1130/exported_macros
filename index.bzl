load("@build_bazel_rules_nodejs//:index.bzl", "nodejs_binary")

def my_binary(name):
    nodejs_binary(
        name = name,
        entry_point = "//:my_binary.js",
        data = [
            "//:my_binary.js",
            "@npm//yargs",
        ],
    )
