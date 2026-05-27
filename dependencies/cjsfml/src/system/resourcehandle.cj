package cjsfml.system

/**
 * Interface for managing SFML resource handles.
 *
 * SFML managed classes implement the `ResourceHandle` interface which extends
 * Cangjie's `Resource` interface with the `handle` property.
 */
public interface ResourceHandle <: Resource {
    /**
     * The internal pointer to the SFML resource.
     */
    prop handle: CPointer<Unit>

    /**
     * Indicates if this instance owns the underlying SFML resource.
     *
     * If `true`, the resource will be destroyed when this object is closed or finalized.
     * Non-owning resources (e.g., textures obtained from a `RenderTexture`) return `false`
     * and should not be manually freed by the user.
     *
     * @return `true` if this instance owns the resource, `false` otherwise.
     */
    prop isOwner: Bool {
        get() {
            true
        }
    }
}
