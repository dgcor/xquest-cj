package dgengine

public class CmdLineUtils {
    // returns true if any export command was found (reagrdless of success)
    public static func processCmdLine(args: Array<String>): Bool {
        if (args.size < 3) {
            // no export options
            return false
        }

        let mountFiles = args[1].split("|")
        var numMountedFiles = 0

        for (mountFile in mountFiles) {
            if (FileUtils.mount(mountFile, "", false) == true) {
                numMountedFiles++
            }
        }
        if (numMountedFiles == 0) {
            return true
        }

        let commandStr = args[0].split(":")

        match (commandStr[0]) {
            case "--export" =>
                if (FileUtils.exists(args[2]) == true) {
                    FileUtils.exportFile(args[2], args[3])
                }
            case _ => ()
        }
        return true
    }
}
