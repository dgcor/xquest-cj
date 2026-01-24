package dgengine

public interface Action {
    operator func ()(game: Game): Bool
}
