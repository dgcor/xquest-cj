package dgengine

import cjsfml.graphics.*
import cjsfml.system.*
import std.collection.*
import std.convert.*
import std.math.*

public class Menu <: ActionQueryable & UIObject {
    private let m_items: ArrayList<TextButton> = ArrayList<TextButton>()
    private var m_closed = false
    private var m_verticalPad: Int32 = 0
    private var m_visibleItems: Int64 = 0
    private var m_currentIdx: Int64 = 0
    private var m_position: Vector2f = Vector2f()
    private var m_vertAlign: VerticalAlign = AlignBottom
    private var m_anchor: Anchor = Anchor.Top | Anchor.Left
    private var m_focusEnable: Bool = false
    private var m_recalculatePositions: Bool = false
    private var m_recalculateVisibleItems: Bool = true
    private var m_start: Int64 = 0
    private var m_end: Int64 = 0
    private var m_scrollPosition: Vector2f = Vector2f()
    private var m_scrollRect: IntRect = IntRect()
    private var m_scrollDownAction: ?Action = None
    private var m_scrollUpAction: ?Action = None
    private var m_visible: Bool = true

    // Resource

    public func isClosed(): Bool {
        m_closed
    }

    public func close(): Unit {
        if (m_closed == false) {
            for (item in m_items) {
                item.close()
            }
            m_items.clear()
            m_closed = true
        }
    }

    // ActionQueryable

    public func getAction(name: String): ?Action {
        match (name) {
            case "scrollDown" => m_scrollDownAction
            case "scrollUp" => m_scrollUpAction
            case _ => None
        }
    }

    public func setAction(name: String, action: ?Action): Bool {
        match (name) {
            case "scrollDown" => m_scrollDownAction = action
            case "scrollUp" => m_scrollUpAction = action
            case _ => return false
        }
        return true
    }

    // UIObject

    public mut prop anchor: Anchor {
        get() {
            m_anchor
        }
        set(value) {
            m_anchor = value
        }
    }

    public func updateSize(game: Game): Unit {
        let pos = Box(m_position)
        let scrollPos = Box(m_scrollPosition)
        let size = Box(size)
        m_anchor.getPosSize(pos, size, game.oldDrawRegionSize, game.drawRegionSize)
        m_anchor.getPosSize(scrollPos, size, game.oldDrawRegionSize, game.drawRegionSize)
        m_position = pos.value
        m_scrollPosition = scrollPos.value

        m_scrollRect.left = Int32(m_scrollPosition.x)
        m_scrollRect.top = Int32(m_scrollPosition.y)

        for (item in m_items) {
            item.updateSize(game)
        }
    }

    public prop drawPosition: Vector2f {
        get() {
            m_position
        }
    }

    public mut prop position: Vector2f {
        get() {
            m_position
        }
        set(value) {
            m_position = value
            if (m_visibleItems > 0) {
                m_recalculatePositions = true
            }
        }
    }

    public mut prop size: Vector2f {
        get() {
            Vector2f(Float32(m_scrollRect.width), Float32(m_scrollRect.height))
        }
        set(value) {
            m_scrollRect.width = Int32(value.x)
            m_scrollRect.height = Int32(value.y)
        }
    }

    public mut prop visible: Bool {
        get() {
            m_visible
        }
        set(value) {
            m_visible = value
        }
    }

    public func draw(game: Game, target: RenderTarget): Unit {
        if (m_visible == false) {
            return
        }
        for (index in m_start..m_end) {
            m_items[index].draw(game, target)
        }
    }

    public override func update(game: Game): Unit {
        if (m_visible == false) {
            return
        }
        let focus = game.resources.getFocused()
        for ((index, button) in m_items |> enumerate) {
            if (m_focusEnable == true) {
                if (let Some(focus) <- focus) {
                    if (isObjEq(button, focus)) {
                        if (m_recalculateVisibleItems == false) {
                            m_recalculateVisibleItems = (m_currentIdx != index)
                        }
                        m_currentIdx = index
                    }
                }
            }
            if (index >= m_start && index < m_end) {
                button.update(game)
            }
        }
        if ((m_recalculatePositions == true || m_recalculateVisibleItems == true) && m_visibleItems > 0) {
            m_recalculatePositions = true
            calculatePositions()
            m_recalculateVisibleItems = false
        }
        if (let Some(scroll) <- game.mouseScroll) {
            if (m_scrollRect.contains(scroll.x, scroll.y)) {
                game.mouseScroll = None
                if (scroll.delta < 0.0) {
                    game.events.addBack(m_scrollDownAction)
                } else {
                    game.events.addBack(m_scrollUpAction)
                }
            }
        }
    }

    public func getProperty(propName: String): ?Variable {
        if (propName.size <= 1) {
            return None
        }
        let props = splitStringIn2(propName, ".")
        return match (props[0]) {
            case "itemCount" => VaInteger(m_items.size)
            case "currentIdx" => VaInteger(m_currentIdx)
            case "visibleItems" => VaInteger(m_visibleItems)
            case "item" =>
                let props2 = splitStringIn2(props[1], '.')
                let itemIdx = Int64.tryParse(props2[0]) ?? 0
                if (let Some(item) <- m_items.get(itemIdx)) {
                    return item.getProperty(props2[1])
                }
                return None
            case _ => getProperty(props[0], props[1])
        }
    }

    // Menu

    public func updateVisibleItems(): Unit {
        if (m_items.isEmpty() == true || m_visibleItems == 0) {
            m_start = 0
            m_end = m_items.size
            return
        }
        if (m_start == 0 && m_end == 0) {
            m_end = min(m_visibleItems, m_items.size)
        } else if (m_currentIdx == 0) {
            m_start = 0
            m_end = min(m_visibleItems, m_items.size)
        } else if (m_currentIdx == m_items.size - 1) {
            if (m_visibleItems < m_items.size) {
                m_start = m_items.size - m_visibleItems
            } else {
                m_start = 0
            }
            m_end = m_items.size
        } else if (m_currentIdx == m_end && m_end < m_items.size) {
            m_start++
            m_end++
        } else if (m_currentIdx < m_start && m_start > 0) {
            m_start--
            m_end--
        }
    }

    public func calculatePositions(): Unit {
        if (m_recalculatePositions == false) {
            return
        }
        m_recalculatePositions = false

        updateVisibleItems()

        if (m_items.isEmpty() == true) {
            return
        }

        var currPos = m_position
        var i = 0
        while (i < m_start) {
            m_items[i].position = currPos
            i++
        }
        var lastSize = 0.0f32
        while (i < m_end) {
            let item = m_items[i]
            item.position = currPos
            lastSize = item.size.y
            if (i + 1 < m_end) {
                currPos.y += lastSize + Float32(m_verticalPad)
            }
            i++
        }
        while (i < m_items.size) {
            m_items[i].position = currPos
            i++
        }
        currPos.y += lastSize
        if (m_vertAlign != AlignBottom) {
            var offset = m_position.y - currPos.y + lastSize
            if (m_vertAlign == VerticalAlign.AlignCenter) {
                offset = round(offset / 2.0)
            }
            for (item in m_items) {
                var itemPos = item.position
                itemPos.y += offset
                item.position = itemPos
            }
        }
    }

    public prop isFocusEnabled: Bool {
        get() {
            m_focusEnable
        }
    }

    public func setFocusEnabled(): Unit {
        m_focusEnable = true
    }

    public func addItem(item: TextButton, recalculatePositions: Bool): Unit {
        m_items.add(item)
        if (recalculatePositions == true || m_vertAlign != AlignBottom) {
            m_recalculatePositions = true
        }
    }

    public func getItem(): ?TextButton {
        m_items.get(m_currentIdx)
    }

    public func getItem(index: Int64): ?TextButton {
        m_items.get(index)
    }

    public func getVisibleItem(index: Int64): ?TextButton {
        m_items.get(m_start + index)
    }

    public prop itemCount: Int64 {
        get() {
            m_items.size
        }
    }

    public func getItemPosition(item: Button): Int64 {
        for ((index, item2) in m_items |> enumerate) {
            if (isObjEq(item, item2)) {
                return index
            }
        }
        return 0
    }

    public func setScrollPosition(position: Vector2f): Unit {
        m_scrollPosition = position
        m_scrollRect.left = Int32(position.x)
        m_scrollRect.top = Int32(position.y)
    }

    public func setVerticalAlign(align: VerticalAlign): Unit {
        if (m_vertAlign != align) {
            m_vertAlign = align
            m_recalculatePositions = true
        }
    }

    public func setVerticalPad(verticalPad: Int32): Unit {
        if (m_verticalPad != verticalPad) {
            m_verticalPad = verticalPad
            m_recalculatePositions = true
        }
    }

    public func setVisibleItems(visibleItems: Int64): Unit {
        if (m_visibleItems == visibleItems) {
            return
        }
        let newVal = min(visibleItems, m_items.size)
        if (m_visibleItems == 0) {
            m_visibleItems = newVal
            if (newVal > 0) {
                m_recalculatePositions = true
            }
        } else {
            if (m_visibleItems != newVal) {
                m_visibleItems = newVal
                m_recalculatePositions = true
            }
        }
    }

    public func setCurrentIdx(index: Int64): Unit {
        if (index >= 0 && index < m_items.size) {
            m_currentIdx = index
            if (index < m_start || index >= m_end) {
                m_recalculateVisibleItems = true
            }
        }
    }

    public func setColor(color: Color): Unit {
        for (item in m_items) {
            item.color = color
        }
    }

    public func setColor(color: Color, index: Int64): Unit {
        if (index >= 0 && index < m_items.size) {
            m_items[index].color = color
        } else {
            setColor(color)
        }
    }

    public func setFont(font: Font): Unit {
        for (item in m_items) {
            item.font = font
        }
    }

    public func setFont(font: Font, index: Int64): Unit {
        if (index >= 0 && index < m_items.size) {
            m_items[index].font = font
        } else {
            setFont(font)
        }
    }
}
