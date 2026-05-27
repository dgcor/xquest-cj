# stdjson2

stdjson2 is a Cangjie package that implements JSON encoding/decoding.  

This is based on `stdx.encoding.json` but with a different public API similar to `rapidjson4cj`.

## Building

### Build Requirements

To build this package, you must have the following tools installed and available in your system's PATH:

*   **C Compiler**: Clang or GCC
*   **CMake**

### How it Works

To use `stdjson2` in your project, download the latest release and extract the `stdjson2` folder
into your project directory. Then, configure your `cjpm.toml` to use it as a binary dependency.

### Static Linking

```toml
[package]
  cjc-version = "1.0.5"
  name = "test"
  description = "nothing here"
  version = "1.0.0"
  target-dir = ""
  output-type = "executable"
  compile-option = ""
  override-compile-option = ""
  link-option = ""
  package-configuration = {}

[target.aarch64-apple-darwin.bin-dependencies]
  path-option = ["stdjson2/darwin_aarch64_cjnative/static/stdjson2"]

[target.x86_64-unknown-linux-gnu.bin-dependencies]
  path-option = ["stdjson2/linux_x86_64_cjnative/static/stdjson2"]

[target.x86_64-w64-mingw32.bin-dependencies]
  path-option = ["stdjson2/windows_x86_64_cjnative/static/stdjson2"]
```

### Dynamic Linking

```toml
[package]
  cjc-version = "1.0.5"
  name = "test"
  description = "nothing here"
  version = "1.0.0"
  target-dir = ""
  output-type = "executable"
  compile-option = ""
  override-compile-option = ""
  link-option = ""
  package-configuration = {}

[target.aarch64-apple-darwin.bin-dependencies]
  path-option = ["stdjson2/darwin_aarch64_cjnative/dynamic/stdjson2"]

[target.x86_64-unknown-linux-gnu.bin-dependencies]
  path-option = ["stdjson2/linux_x86_64_cjnative/dynamic/stdjson2"]

[target.x86_64-w64-mingw32.bin-dependencies]
  path-option = ["stdjson2/windows_x86_64_cjnative/dynamic/stdjson2"]
```

## License

Apache License
