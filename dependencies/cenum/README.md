# cenum

cenum is a cangjie macro package that mimics C like enums.

## Macros

* Enum - C like enum (starts at 0)
* CEnum - C like enum ABI compatible with C (starts at 0)
* FlagEnum - C like flags enum (starts at 0)
* FlagEnum0 - C like flags enum (starts at 0)
* FlagEnum1 - C like flags enum (starts at 1)
* CFlagEnum - C like flags enum ABI compatible with C (starts at 0)
* CFlagEnum0 - C like flags enum ABI compatible with C (starts at 0)
* CFlagEnum1 - C like flags enum ABI compatible with C (starts at 1)

## Examples

### Simple enum

Generates a `struct` that holds an `Int32` value.

```
@Enum[SimpleEnum](
    Val1  // 0
    Val2  // 1
    Val3  // 2
)
```

### C compatible enum

The underlying generated struct has the `@C` annotation and can be passed to `foreign` functions.
The size of the struct is `Int32` by default. Structs are passed by value in Cangjie.

```
@CEnum[SimpleEnum](
    Val1 = 1  // 1
    Val2      // 2
    Val3      // 3
)
```

### Flags enum

Flags enum that automatically uses the next free value by default.

```
@FlagEnum[SimpleFlagEnum](
    None  // 0
    Val1  // 1
    Val2  // 2
    Val3  // 4
)

...

let flags = SimpleFlagEnum.Val2 | SimpleFlagEnum.Val3
flags.isSet(SimpleFlagEnum2.Val2)
```

## License

MIT No Attribution
