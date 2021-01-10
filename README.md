# Exported Macros

GitHub repository for minimally reproducing a `rules_nodejs` bug.

In `rules_nodejs` v3, `strict_visibility` is enabled by default. This is great
to avoid accidentally depending on a transitive dep, but causes other
challenges. Most notably, strict deps cannot take into account dependencies from
macros originating in Bazel libraries.

In this example, this workspace provides a [`my_binary()`](/index.bzl) macro
which generates a `nodejs_binary()`. This binary happens to use `yargs` as a
dependency to parse arguments. It is listed in the `package.json` and works
correctly when used in this workspace's [`BUILD.bazel`](/BUILD.bazel) file.

```
$ bazel run //:binary -- --foo bar
bar
```

However, in [`external`](/external/) is a separate workspace which depends on
this example via NPM and calls the same macro. Attempting to use it throws an
error:

```
$ bazel run //:pkg.pack && \
    (cd external/ && npm install && npm install ../exported_macros-*.tgz && bazel run //:binary -- --foo bar)
# ...
ERROR: /home/dparker/Source/exported_macros/external/BUILD.bazel:3:10: in nodejs_binary rule //:binary: target '@npm//yargs:yargs' is not visible from target '//:binary'. Check the visibility declaration of the former target if you think the dependency is legitimate
ERROR: Analysis of target '//:binary' failed; build aborted: Analysis of target '//:binary' failed
```

Because the macro is executed in a separate workspace, and that workspace does
**not** have a dependency on `yargs`, the generated `nodejs_binary()` fails the
strict visibility check.
