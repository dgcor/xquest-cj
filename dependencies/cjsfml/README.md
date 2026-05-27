# cjsfml

cjsfml - SFML 3 library bindings for cangjie.

https://www.sfml-dev.org/

SFML is a simple, fast, cross-platform and object-oriented multimedia API.
It provides access to windowing, graphics, audio and network.
It is written in C++, and has bindings for various languages.

## Resource Management

SFML managed classes implement the `ResourceHandle` interface which extends
cangjie's `Resource` interface with the `handle` property.

```
// ResourceHandle

public func isClosed(): Bool

public func close(): Unit

public prop handle: CPointer<Unit>
```

Classes also implement destructors to free resources. Destructors are invoked by
cangjie's garbage collector or by calling `gc()` directly. Programs don't have to
do resource management and can free unused resources by simply calling `gc()`.  

It is important to free `Texture` resources when not in use as they take up GPU memory.

### Non-owning resources

Some classes, like `Texture`, can be constructed as owning or non owning. SFML
returns textures that are not supposed to be freed (`RenderTexture`) and as such `cjsfml`
returns non owning `Texture`s for SFML internal resources. It's safe to call `close()`
on these objects. These objects shouldn't be used after the owning object has been freed.

## Building

To use `cjsfml` in your project, download the latest release and extract the `cjsfml` folder
into your project directory. Then, configure your `cjpm.toml` to use it as a binary dependency.

### Static Linking

When linking statically, you must explicitly provide the CSFML link options in your `cjpm.toml`.

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
  link-option = "-lcsfml-audio -lcsfml-graphics -lcsfml-system -lcsfml-window"
  package-configuration = {}

[target.x86_64-unknown-linux-gnu.bin-dependencies]
  path-option = ["cjsfml/linux_x86_64_cjnative/static/cjsfml"]

[target.x86_64-w64-mingw32.bin-dependencies]
  path-option = ["cjsfml/windows_x86_64_cjnative/static/cjsfml"]
```

### Dynamic Linking

When linking dynamically, you do not need to specify `link-option`. However, you must ensure
that the SFML and CSFML shared libraries (`.so` or `.dll` files) included in the release's
`sfml` folder are placed in the same directory as your compiled executable at runtime.

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
  path-option = ["cjsfml/linux_x86_64_cjnative/dynamic/cjsfml"]

[target.x86_64-w64-mingw32.bin-dependencies]
  path-option = ["cjsfml/windows_x86_64_cjnative/dynamic/cjsfml"]
```

## License

zlib
