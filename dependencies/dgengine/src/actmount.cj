package dgengine

public class ActMount <: Action {
    public ActMount(
        private let file: String,
        private let mountPoint: String,
        private let appendToSearchPath: Bool,
        private let useSaveDir: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        let file2 = match (useSaveDir) {
            case true => FileUtils.getSaveDir() + file
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

    public operator func ()(game: Game): Bool {
        let file2 = match (useSaveDir) {
            case true => FileUtils.getSaveDir() + file
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
