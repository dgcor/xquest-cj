package dgengine

public class ActLoad <: Action {
    private let args: Array<String>

    public init(args: Array<String>) {
        this.args = args
    }

    public init(file: String) {
        args = [file]
    }

    public operator func ()(game: Game): Bool {
        if (args.size > 0) {
            if (args.size == 1) {
                parseFile(game, args[0])
            } else {
                parseFile(game, args)
            }
        }
        return true
    }
}

public class ActLoadJson <: Action {
    public ActLoadJson(
        private let json: String,
        private let args!: Array<String> = Array<String>()
    ) {}

    public operator func ()(game: Game): Bool {
        if (args.isEmpty() == true) {
            parseJson(game, json)
        } else {
            parseJson(game, json, args)
        }
        return true
    }
}

public class ActLoadRandom <: Action {
    private let args: Array<String>
    private let endsWith: String

    public init(args: Array<String>, endsWith: String) {
        this.args = args
        this.endsWith = endsWith
    }

    public init(file: String, endsWith: String) {
        args = [file]
        this.endsWith = endsWith
    }

    public operator func ()(game: Game): Bool {
        if (args.size > 0) {
            let files = FileUtils.getFileList(args[0], endsWith, getFullPath: true)
            if (files.size > 0) {
                let idx = Random.get(files.size - 1)
                let file = files[idx]
                if (args.size == 1) {
                    parseFile(game, file)
                } else {
                    let args2 = args
                    args2[0] = file
                    parseFile(game, args2)
                }
            }
        }
        return true
    }
}
