-- Button.lua

-- This tab contains the Unit.button class, which is simply a touch-sensitive version of Unit.textPanel.
-- The init method requires a table of touch event functions, and can optionally include a highlight style and children.
-- Don't ask me why there isn't a class for buttons without text. Buttons have got to have SOMETHING on them, right?

Unit.button = class(Unit.textPanel)

function Unit.button:init(params, children)
    Unit.textPanel.init(self, params, children)
    self.touchEvents = params.touchEvents or Unit.style.touchEvents
    self.hold = params.hold
    self.isHeld = false
    self.defaultStyle = self.style
    self.priority = params.priority or self.layer
    local h = params.highlight
    self.highlightTouchEvent = params.highlightTouchEvent or Unit.style.highlightTouchEvent
    if h then
        self.highlightStyle = {
            asset = h.asset or self.style.asset,
            tint = h.tint or self.style.tint,
            fill = h.fill or self.style.fill,
            stroke = h.stroke or self.style.stroke,
            strokeWidth = h.strokeWidth or self.style.strokeWidth,
            scale = h.scale or self.style.scale,
            rotate = h.rotate or self.style.rotate
        }
    else self.highlightStyle = self.defaultStyle end
    self.toucher = Unit.addToucher(self, self.touchEvents, self.priority, params.share)
    --self.styleTween = tween.delay(1)
end

function Unit.button:draw()
    Unit.textPanel.draw(self)
    if self.hold and self.isHeld then self.hold(self) end
end

function Unit.button:hit(touch)
    local bl, tr = self:getCorners()
    if touch.x > bl.x and touch.y > bl.y and touch.x < tr.x and touch.y < tr.y then return true end
    return false
end

function Unit.button:highlight(bool)
    if bool then self.style = self.highlightStyle else self.style = self.defaultStyle end
end

-- This is the uber-spooky screen that appears if you deleted Defaults.lua and still refused to define a screen!! :O
Unit.noScreen = Unit.screen({},{
    Unit.textPanel({w=1,text="UI error:\nNo screen defined",textFill=color(255),size=20})
})
