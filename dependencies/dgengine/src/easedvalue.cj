package dgengine

public type EasingFunc = (t: Float64, b: Float64, c: Float64, d: Float64) -> Float64

public class EasedValue {
    private let m_easingFunc: EasingFunc
    private var m_startValue = 0.0 // current value, if easing is disabled/finished
    private var m_diffValue = 0.0
    private var m_currentTime = 0.0
    private var m_stopTime = 0.0

    public init(easingFunc!: EasingFunc = easeOutQuart, value!: Float64 = 0.0) {
        m_easingFunc = easingFunc
        m_startValue = value
    }

    private func easingEnabled(): Bool {
        m_stopTime > 0.0
    }

    // false if easing is disabled
    private func hasNewValue(): Bool {
        m_currentTime < m_stopTime
    }

    private func getEased(): Float64 {
        return m_easingFunc(
            m_currentTime,
            m_startValue,
            m_diffValue,
            m_stopTime
        )
    }

    private func getEasedFinal(): Float64 {
        return m_easingFunc(
            m_stopTime,
            m_startValue,
            m_diffValue,
            m_stopTime
        )
    }

    // Uses current value as starting value if easing is enabled
    // if duration <= 0, easing is disabled
    public func set(value: Float64, stopTime: Float64): Unit {
        if (stopTime <= 0.0) {
            // if easing disabled
            m_stopTime = stopTime
            m_startValue = value
            m_currentTime = stopTime
        } else {
            // if easing enabled
            if (hasNewValue() == true) {
                m_startValue = get()
            }
            m_stopTime = stopTime
            m_diffValue = value - m_startValue
            m_currentTime = 0.0
        }
    }

    // current value
    public func get(): Float64 {
        if (hasNewValue() == false) {
            return m_startValue
        } else {
            return getEased()
        }
    }

    // final value
    public func getFinal(): Float64 {
        if (hasNewValue() == false) {
            return m_startValue
        } else {
            return getEasedFinal()
        }
    }

    public func update(elapsedTime: Float64): Unit {
        if (hasNewValue() == false) {
            return
        }
        if (easingEnabled() == true) {
            m_currentTime += elapsedTime
            if (m_currentTime >= m_stopTime) {
                m_currentTime = m_stopTime
                m_startValue = getEasedFinal()
            }
        }
    }
}
