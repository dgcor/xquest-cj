package customiterators.test

import customiterators.{peek, PeekIterator, reverse, ReverseArrayIterator, ReverseArrayListIterator}
import std.collection.{ArrayList, enumerate}

// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
func test_PeekIterator() {
    let str = "abc"
    let it = str.runes().iterator()

    @Expect(it.next(), r'a')
    @Expect(it.next(), r'b')
    @Expect(it.next(), r'c')
    @Expect(it.next().isNone())

    let peekIt = str.runes() |> peek

    @Expect(peekIt.peek(), r'a')
    @Expect(peekIt.next(), r'a')
    @Expect(peekIt.peek(), r'b')
    @Expect(peekIt.next(), r'b')
    @Expect(peekIt.peek(), r'c')
    @Expect(peekIt.next(), r'c')
    @Expect(peekIt.peek().isNone())
    @Expect(peekIt.next().isNone())

    let emptyIt = PeekIterator("".runes().iterator())

    @Expect(emptyIt.peek().isNone())
    @Expect(emptyIt.next().isNone())
    @Expect(emptyIt.peek().isNone())
    @Expect(emptyIt.next().isNone())
}

@Test
func test_ReverseArrayIterator() {
    let arr = [r'a', r'b', r'c']
    let it = ReverseArrayIterator(arr)

    @Expect(it.next(), r'c')
    @Expect(it.next(), r'b')
    @Expect(it.next(), r'a')
    @Expect(it.next().isNone())

    let emptyIt = ReverseArrayIterator(Array<Rune>())

    @Expect(emptyIt.next().isNone())
    @Expect(emptyIt.next().isNone())

    for ((index, rune) in arr |> reverse |> enumerate) {
        match (index) {
            case 0 => @Expect(rune, r'c')
            case 1 => @Expect(rune, r'b')
            case 2 => @Expect(rune, r'a')
            case _ => @Expect(false)
        }
    }
}

@Test
func test_ReverseArrayListIterator() {
    let arr = ArrayList<Rune>([r'a', r'b', r'c'])
    let it = ReverseArrayListIterator(arr)

    @Expect(it.next(), r'c')
    @Expect(it.next(), r'b')
    @Expect(it.next(), r'a')
    @Expect(it.next().isNone())

    let emptyIt = ReverseArrayListIterator(ArrayList<Rune>())

    @Expect(emptyIt.next().isNone())
    @Expect(emptyIt.next().isNone())

    for ((index, rune) in arr |> reverse |> enumerate) {
        match (index) {
            case 0 => @Expect(rune, r'c')
            case 1 => @Expect(rune, r'b')
            case 2 => @Expect(rune, r'a')
            case _ => @Expect(false)
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
