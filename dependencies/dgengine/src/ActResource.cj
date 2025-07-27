package dgengine

public class ActResourceAdd <: Action {
    public ActResourceAdd(
        private let id: String,
        private var ignorePrevious!: ?IgnoreResource = None
    ) {}

    public func setIgnorePrevious(ignore: IgnoreResource): Unit {
        ignorePrevious = ignore
    }

    public operator func ()(game: Game): Bool {
        if (let Some(ignore) <- ignorePrevious) {
            game.resources.ignoreTopResource(ignore)
        }
        game.resources.addResource(id)
        return true
    }
}

public class ActResourceBringToFront <: Action {
    public ActResourceBringToFront(private let id: String) {}

    public operator func ()(game: Game): Bool {
        if (id.isEmpty() == false) {
            game.resources.bringResourceToFront(id)
        }
        return true
    }
}

public class ActResourceIgnore <: Action {
    public ActResourceIgnore(
        private let id: String,
        private let ignore: IgnoreResource
    ) {}

    public operator func ()(game: Game): Bool {
        game.resources.ignoreResources(id, ignore)
        return true
    }
}

public class ActResourcePop <: Action {
    public ActResourcePop(
        private let id: String,
        private let ignorePrevious: IgnoreResource
    ) {}

    public operator func ()(game: Game): Bool {
        if (id.size > 0) {
            game.resources.popResource(id)
        } else {
            game.resources.popResource()
        }
        game.resources.ignoreTopResource(ignorePrevious)
        return true
    }
}

public class ActResourcePopAll <: Action {
    public ActResourcePopAll(
        private let id: String,
        private let popBaseResources: Bool,
        private let ignorePrevious: IgnoreResource
    ) {}

    public operator func ()(game: Game): Bool {
        if (id.size > 0) {
            game.resources.popAllResources(id)
        } else {
            game.resources.popAllResources(popBaseResources)
        }
        game.resources.ignoreTopResource(ignorePrevious)
        return true
    }
}
