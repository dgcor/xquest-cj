package XQuest

import dgengine.*

main(args: Array<String>) {
    try {
        logger.info("Welcome to XQuest!")

        registerHooks()
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
        logger.error(ex.toString())
        ex.printStackTrace()
    } catch (ex: Error) {
        logger.error(ex.toString())
        ex.printStackTrace()
    } finally {
        FileUtils.deinitPhysFS()
        logger.info("Goodbye!")
    }
    return 0
}
