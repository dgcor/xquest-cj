# physfs4cj

physfs4cj is a Cangjie package that provides bindings for PhysicsFS, a portable,
flexible file I/O abstraction library. It allows you to access files in a directory-independent
way, making it ideal for games and applications that need to read assets from archives (ZIP, 7z, etc.)
or specific platform directories.

## Building

### Build Requirements

To build this package, you must have the following tools installed and available in your system's PATH:

*   **C Compiler**: Clang or GCC
*   **CMake**

Only zip and 7z archive formats are enabled. You can enable more archives by modifying `physfs/CMakePresets.json`.

### How it Works

This library bundles a compiled static version of **PhysicsFS** directly within the package. 

*   **No External Dependencies**: You do not need to ship a separate `physfs.dll`, `libphysfs.so`,
      or `physfs.dylib` with your application. The library self-contains the native code.
*   **Native Cangjie FFI**: All functions from the C API are exposed as API calls in the resulting
      dynamic library. This allows you to access low-level PhysFS functionality directly using Cangjie's
      `foreign` keyword if the wrapped bindings don't cover your specific use case.

`physfs4cj` bundles `libphysfs.a` into `libphysfs4cj.a` using `ar` in a `post-build` step in `build.cj`.

To use `physfs4cj` in your project, download the latest release and extract the `physfs4cj` folder
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

[target.x86_64-unknown-linux-gnu.bin-dependencies]
  path-option = ["physfs4cj/linux_x86_64_cjnative/static/physfs4cj"]

[target.x86_64-w64-mingw32.bin-dependencies]
  path-option = ["physfs4cj/windows_x86_64_cjnative/static/physfs4cj"]
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

[target.x86_64-unknown-linux-gnu.bin-dependencies]
  path-option = ["physfs4cj/linux_x86_64_cjnative/dynamic/physfs4cj"]

[target.x86_64-w64-mingw32.bin-dependencies]
  path-option = ["physfs4cj/windows_x86_64_cjnative/dynamic/physfs4cj"]
```

## Examples

### Initialize, Mount, and Read a File

This example demonstrates the typical lifecycle: initializing the library, mounting a directory
(or archive), reading a file, and cleaning up.

```cangjie
import physfs4cj.PhysFS

main() {
    try {
        // 1. Initialize the library
        PhysFS.initialize()

        // 2. Mount a directory (assumes "test_data" folder exists in cwd)
        PhysFS.mount("test_data", mountPoint: "/", appendToPath: true)
        println("Mounted 'test_data' successfully.")

        // 3. Check if a file exists in the virtual path
        if (PhysFS.exists("config.json")) {
            println("Found 'config.json' in the virtual file system.")

            // Get the real physical path (returns ?String)
            let realPath = PhysFS.getRealDir("config.json") ?? "Unknown"
            println("Physical location: ${realPath}")
        } else {
            println("'config.json' not found.")
        }

        // Example of handling a non-existent file
        let missingPath = PhysFS.getRealDir("missing.file")
        if (missingPath.isNone()) {
            println("Correctly handled missing file (returned None).")
        }

    } catch (e: Exception) {
        println("PhysFS Error: ${e}")
    } finally {
        // 4. Always deinitialize to clean up resources
        PhysFS.deinitialize()
    }
}
```

## License

zlib License
