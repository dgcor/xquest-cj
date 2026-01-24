package dgengine

import std.collection.*

public class ActDirCopy <: Action {
    public ActDirCopy(
        private let dirSrc: String,
        private let dirDst: String
    ) {}

    public operator func ()(game: Game): Bool {
        FileUtils.copyDir(
            GameUtils.replaceStringWithVarOrProp(dirSrc, game),
            GameUtils.replaceStringWithVarOrProp(dirDst, game)
        )
        return true
    }
}

public class ActDirCreate <: Action {
    public ActDirCreate(private let dir: String) {}

    public operator func ()(game: Game): Bool {
        FileUtils.createDir(GameUtils.replaceStringWithVarOrProp(dir, game))
        return true
    }
}

public class ActFileCopy <: Action {
    public ActFileCopy(
        private let dir: String,
        private let filesRead: Array<String>,
        private let fileWrite: String,
        private let nullText: String,
        private let replaceVars: ReplaceVars
    ) {}

    public operator func ()(game: Game): Bool {
        if (filesRead.size > 0) {
            let fileRead = filesRead[0]
            var str = FileUtils.readText(GameUtils.replaceStringWithVarOrProp(fileRead, game))

            var paramName = String.empty // cjlint-ignore !G.VAR.02 minimize scope

            for ((index, varStr) in filesRead[1..filesRead.size] |> enumerate) {
                if ((varStr.size > 2) && varStr.startsWith('%') && varStr.endsWith('%')) {
                    if (let Some(var2) <- game.getVarOrProp(varStr)) {
                        paramName = var2.toString()
                    } else {
                        paramName = nullText
                    }
                } else {
                    paramName = varStr
                }
                str = str.replace("{${index}}", paramName)
            }

            if (replaceVars != ReplaceNone) {
                let changeValueType = replaceVars == ReplaceValue
                if (let Some(doc) <- JsonUtils.loadJsonAndReplaceValues(str, game, changeValueType: changeValueType,
                    token: '|')) {
                    str = JsonUtils.jsonToPrettyString(doc)
                }
            }

            var writePath = GameUtils.replaceStringWithVarOrProp(dir, game)
            if (writePath.size > 0 && writePath.endsWith('/') == false) {
                writePath += '/'
            }
            if (fileWrite.size > 0) {
                writePath += game.getVarOrPropStringS(fileWrite)
            } else {
                writePath += game.getVarOrPropStringS(FileUtils.getFileName(fileRead))
            }
            FileUtils.saveText(writePath, str)
        }
        return true
    }
}

public class ActIODelete <: Action {
    public ActIODelete(private let dir: String) {}

    public operator func ()(game: Game): Bool {
        FileUtils.deleteFile(GameUtils.replaceStringWithVarOrProp(dir, game))
        return true
    }
}

public class ActIODeleteAll <: Action {
    public ActIODeleteAll(
        private let dir: String,
        private let deleteRoot: Bool
    ) {}

    public operator func ()(game: Game): Bool {
        FileUtils.deleteAll(GameUtils.replaceStringWithVarOrProp(dir, game), deleteRoot: deleteRoot)
        return true
    }
}
