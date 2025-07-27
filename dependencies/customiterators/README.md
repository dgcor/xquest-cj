# customiterators

customiterators is a collection of custom iterators for cangjie.

## Iterators

* PeekIterator - Peek iterator implementation
* ReverseArrayIterator - Reverse iterator implementation for Array
* ReverseArrayListIterator - Reverse iterator implementation for ArrayList

## Functions

* peek
* reverse

## Examples

### PeekIterator

```
let str = "abc"
let peekIt = PeekIterator(str.runes())

@Expect(peekIt.peek(), r'a')
@Expect(peekIt.next(), r'a')
@Expect(peekIt.peek(), r'b')
@Expect(peekIt.next(), r'b')
```

### peek function

```
let str = "abc"
let peekIt = str.runes() |> peek

@Expect(peekIt.peek(), r'a')
@Expect(peekIt.next(), r'a')
@Expect(peekIt.peek(), r'b')
@Expect(peekIt.next(), r'b')
```

### ReverseArrayIterator

```
let arr = [r'a', r'b', r'c']
let it = ReverseArrayIterator(arr)

@Expect(it.next(), r'c')
@Expect(it.next(), r'b')
@Expect(it.next(), r'a')
@Expect(it.next().isNone())
```

### reverse function

```
let arr = [r'a', r'b', r'c']

for ((index, rune) in arr |> reverse |> enumerate) {
    match (index) {
        case 0 => @Expect(rune, r'c')
        case 1 => @Expect(rune, r'b')
        case 2 => @Expect(rune, r'a')
        case _ => @Expect(false)
    }
}
```

## License

MIT No Attribution
