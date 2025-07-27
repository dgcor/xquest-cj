# DGEngine

DGEngine is a 2D game engine for the Cangjie programming language.

### Documentation

Documentation on DGEngine under [docs](docs/readme.md).

### Example

Here is a simple example on how to use DGEngine:

```cangjie
package example

import dgengine.*

main(args: Array<String>) {
    try {
        FileUtils.initPhysFS()

        try (game = Game()) {
            if (CmdLineUtils.processCmdLine(args) == false) {
                if (args.size == 1) {
                    game.load(args[0], "main.json")
                } else if (args.size == 2) {
                    game.load(args[0], args[1])
                } else {
                    game.load(".", "main.json")
                }
                game.play()
            }
        }
    } catch (ex: Exception) {
        println(ex.toString())
    } catch (ex: Error) {
        println(ex.toString())
    } finally {
        FileUtils.deinitPhysFS()
    }
    return 0
}
```
