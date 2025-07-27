package dgengine

import cjsfml.system.*

public struct ElapsedTime {
    public var timeout: Time = Time.zero
    public var currentTime: Time = Time.zero

    public init(timeout!: Time = Time.zero) {
        this.timeout = timeout
    }

    public mut func reset(): Unit {
        currentTime = Time.zero
    }

    // reset time, and keep the remainder
    public mut func update(elapsedTime: Time): Bool {
        if (timeout == Time.zero) {
            return true
        }
        currentTime += elapsedTime
        if (currentTime >= timeout) {
            currentTime = currentTime % timeout
            return true
        }
        return false
    }

    // reset time, and reset the remainder
    public mut func updateAndReset(elapsedTime: Time): Bool {
        currentTime += elapsedTime
        if (currentTime >= timeout) {
            currentTime = Time.zero
            return true
        }
        return false
    }

    // reset time, and subtract the remainder
    public mut func updateAndSubtract(elapsedTime: Time): Bool {
        currentTime += elapsedTime
        if (currentTime >= timeout) {
            currentTime -= timeout
            return true
        }
        return false
    }

    // execute function on each timeout while currentTime >= timeout
    // and subtract timeout on each iteration
    public mut func update(elapsedTime: Time, function: () -> Unit): Unit {
        currentTime += elapsedTime
        while (currentTime >= timeout) {
            currentTime -= timeout
            function()
        }
    }

    // execute function on each timeout while currentTime >= timeout
    // and subtract timeout on each iteration or until function returns false
    public mut func update(elapsedTime: Time, function: () -> Bool): Unit {
        currentTime += elapsedTime
        while (currentTime >= timeout) {
            currentTime -= timeout
            if (function() == false) {
                break
            }
        }
    }
}

public struct ElapsedTimef {
    public var timeout: Float32 = 0.0
    public var currentTime: Float32 = 0.0

    public init(timeout!: Float32 = 0.0) {
        this.timeout = timeout
    }

    public mut func reset(): Unit {
        currentTime = 0.0
    }

    // same as updateAndReset
    public mut func update(elapsedTime: Float32): Bool {
        updateAndReset(elapsedTime)
    }

    // reset time, and reset the remainder
    public mut func updateAndReset(elapsedTime: Float32): Bool {
        currentTime += elapsedTime
        if (currentTime >= timeout) {
            currentTime = 0.0
            return true
        }
        return false
    }

    // reset time, and subtract the remainder
    public mut func updateAndSubtract(elapsedTime: Float32): Bool {
        currentTime += elapsedTime
        if (currentTime >= timeout) {
            currentTime -= timeout
            return true
        }
        return false
    }

    // execute function on each timeout while currentTime >= timeout
    // and subtract timeout on each iteration
    public mut func update(elapsedTime: Float32, function: () -> Unit): Unit {
        currentTime += elapsedTime
        while (currentTime >= timeout) {
            currentTime -= timeout
            function()
        }
    }

    // execute function on each timeout while currentTime >= timeout
    // and subtract timeout on each iteration or until function returns false
    public mut func update(elapsedTime: Float32, function: () -> Bool): Unit {
        currentTime += elapsedTime
        while (currentTime >= timeout) {
            currentTime -= timeout
            if (function() == false) {
                break
            }
        }
    }
}
