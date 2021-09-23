-- Char.lua
-- IMPORTANT: This file is currently too early in development to use.
-- Eventually, rich text editing will be possible in Codea apps.

-- This tab handles the drawing and defining of rich text with the Unit.char and Unit.label classes.
-- It also allows the attributes of each character to be defined, which opens up many possibilities.

Unit.char = class()

function Unit.char:init(character, parameters)
    --assert(string.len(character)==1)
    self.text = character
    local p = parameters or {}
    -- Theoretically, giving each character its own attributes allows for in-depth text editing. All I want to do for now is record the coordinates of each character, however. Maybe a future update.
    self.font = p.font or "AmericanTypewriter"
    self.size = p.size or 17
    self.fill = p.fill or color(0)
    self.align = LEFT
    self:updateSize()
    self.x = p.x or WIDTH/2
    self.y = p.y or HEIGHT/2
    self.wrap = p.wrap or WIDTH
end

function Unit.char:updateSize()
    pushStyle()
    font(self.font)
    fontSize(10000) -- Because textSize() always returns an integer, high font sizes are required for precision. It gets a bit glitchy if it is too high, however.
    local w,h = textSize(self.text)
    self.w = w*self.size/10000
    self.h = h*self.size/10000
    
    --fontSize(self.size) table.transfer(self, fontMetrics())
    popStyle()
end

function Unit.char:draw()
    pushStyle()
    fill(self.fill)
    font(self.font)
    fontSize(self.size)
    textWrapWidth(self.wrap)
    textAlign(self.align)
    textMode(CORNER) -- This is the only text draw mode allowed right now.
    text(self.text, self.x, self.y)
    popStyle()
end

Unit.label = class(Unit.char)

function Unit.label:init(str, parameters)
    assert(str, "Label initialized without string!")
    Unit.char.init(self, str, parameters)
    local chars = {}
    for i=1, string.len(self.text) do
        table.insert(chars, Unit.char(string.sub(str, i, i), parameters))
    end
    self.chars = chars
    self:sizeChanged(WIDTH, HEIGHT)
end

function Unit.label:sizeChanged(w, h)
    self.wrap = w
    self.lines = 1
    self.align = LEFT
    local currentX = self.x
    local currentY = self.y
    self.chars[1].x = currentX
    self.chars[1].y = currentY
    currentX = currentX + self.chars[1].w
    for k,v in ipairs(self.chars) do
        if self.chars[1] ~= v then
            if currentX - self.x > w - v.w then
                currentY = self.y - v.h*self.lines
                currentX = self.x
                self.lines = self.lines + 1 
            end
            v.x = currentX
            v.y = currentY
            currentX = currentX + v.w
        end
    end
end


