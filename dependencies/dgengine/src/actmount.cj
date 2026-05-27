package dgengine

public class ActMount <: Action {
    public ActMount(
        private let file: String,
        private let mountPoint: String,
        private let appendToSearchPath: Bool,
        private let useSaveDir: Bool
    ) {}

    /**
     * @throws Exception
     */
    public operator func ()(game: Game): Bool {
        let saveDir = FileUtils.getSaveDir() ?? throw Exception("ActMount: saveDir is None")
        let file2 = match (useSaveDir) {
            case true => saveDir + file
            case false => game.path + file
        }
        FileUtils.mount(file2, mountPoint, appendToSearchPath)
        return true
    }
}

public class ActUnmount <: Action {
    public ActUnmount(
        private let file: String,
        private let useSaveDir: Bool
    ) {}

    /**
     * @throws Exception
     */
    public operator func ()(game: Game): Bool {
        let saveDir = FileUtils.getSaveDir() ?? throw Exception("ActUnmount: saveDir is None")
        let file2 = match (useSaveDir) {
            case true => saveDir + file
            case false => game.path + file
        }
        FileUtils.unmount(file2)
        return true
    }
}

public class ActUnmountAll <: Action {
    public operator func ()(_: Game): Bool {
        FileUtils.unmountAll()
        return true
    }
}
