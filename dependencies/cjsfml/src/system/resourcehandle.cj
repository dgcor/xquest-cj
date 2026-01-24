package cjsfml.system

public interface ResourceHandle <: Resource {
    prop handle: CPointer<Unit>

    prop isOwner: Bool {
        get() {
            true
        }
    }
}
