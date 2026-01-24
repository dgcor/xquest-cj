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

## License

zlib
