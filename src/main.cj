package xquest

import dgengine.*
import std.env.getStdOut
import stdlog.{LogLevel, setGlobalLogger}
import stdlog.logger.SimpleLogger

@When[os == "Windows"]
foreign func AttachConsole(processId: UInt32): Bool

@When[debug]
const LOG_LEVEL = LogLevel.DEBUG
@When[!debug]
const LOG_LEVEL = LogLevel.INFO

main(args: Array<String>) {
    try {
        let logger = SimpleLogger(getStdOut())
        logger.level = LOG_LEVEL
        setGlobalLogger(logger)

        // print logs to the console on windows if parent process is console
        @When[os == "Windows"]
        let _ = unsafe { AttachConsole(0xFFFFFFFFu32) }

        LOGGER.info("Welcome to XQuest!")

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
        LOGGER.error(ex.toString())
        ex.printStackTrace()
    } catch (ex: Error) {
        LOGGER.error(ex.toString())
        ex.printStackTrace()
    } finally {
        FileUtils.deinitPhysFS()
        LOGGER.info("Goodbye!")
    }
    return 0
}
