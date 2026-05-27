package cjsfml.system

/**
 * Base class for SFML exceptions.
 */
public class SFMLException <: Exception {
    public init() {
        super()
    }

    public init(message: String) {
        super(message)
    }
}

/**
 * Exception thrown when an SFML handle is null.
 */
public class SFMLNullHandleException <: Exception {
    public init(message!: String = "SFML Handle is null") {
        super(message)
    }
}

/**
 * Exception thrown when an out-of-bounds access is attempted.
 */
public class SFMLOutOfBoundsException <: Exception {
    public init(message!: String = "Out of bounds access") {
        super(message)
    }
}
