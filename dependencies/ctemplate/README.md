# ctemplate

ctemplate is a cangjie macro package that mimics C++ templates.

## Macros

* Template - C++ like template macro

## Examples

### 1 template parameter

This code generates 3 function overloads: `Int32`, `Int64` and `Float32`

```
@Template[T: Int32, Int64, Float32](
func getNum(n: T): T {
    var ret = unsafe { zeroValue<T>() }
    ret += n
    return ret
})
```

### multiple template parameters

This code generates 2 function overloads: `Float32, Int32` and `Float64, Int64`

```
@Template[T, U: Float32, Int32 ; Float64, Int64](
func round(num: T, digits: U): T {
    let fac = pow(10.0, digits)
    return round(num * fac) / fac
})
```

## License

MIT No Attribution
