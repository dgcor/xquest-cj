package dgengine

public interface ActionQueryable {
    func getAction(name: String): ?Action

    func setAction(name: String, action: ?Action): Bool
}
