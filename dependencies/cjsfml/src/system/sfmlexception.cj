package cjsfml.system

public class SFMLException <: Exception {
    public init() {
        super()
    }

    public init(message: String) {
        super(message)
    }
}

public class SFMLNullHandleException <: Exception {
    public init(message!: String = "SFML Handle is null") {
        super(message)
    }
}

public class SFMLOutOfBoundsException <: Exception {
    public init(message!: String = "Out of bounds access") {
        super(message)
    }
}
