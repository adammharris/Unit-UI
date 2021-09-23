-- Panel.lua

-- This tab contains the Unit.panel class, which manages the drawing of rectangles as UI elements. 
-- It contains basic metadata, draw information, a frame manager function, and sometimes children.
-- It is often a parent class for other UI elements.
-- See below simple child classes like Unit.screen and Unit.textPanel.

Unit.panel = class()

function Unit.panel:init(p, children)
    assert(p, "PANEL is missing parameters!")
    self.name = p.name or Unit.style.name -- sometimes used in debugging and error handling
    self.id = p.id -- unused
    self.relativeFrame = { -- defines the size of the panel relative to its parent.
        x = p.x or Unit.style.relativeFrame.x,
        y = p.y or Unit.style.relativeFrame.y,
        w = p.w or Unit.style.relativeFrame.w,
        h = p.h or Unit.style.relativeFrame.h
    }
    self.rawFrame = {} -- will contain the actual x, y, w, and h values for drawing
    self.frameManager = p.frameManager
    if self.frameManager == nil then -- set default frame manager
        self.frameManager = Unit.style.frameManager
    end
    self.layer = p.layer or Unit.style.layer -- determines the order in which panels are drawn
    self.drawMode = p.drawMode or Unit.style.drawMode
    self.style = p.style or { -- contains interchangeable information related to drawing.
        fill = p.fill or Unit.style.fill,
        asset = p.asset or Unit.style.asset,
        tint = p.tint or Unit.style.tint,
        stroke = p.stroke or Unit.style.stroke,
        strokeWidth = p.strokeWidth or Unit.style.strokeWidth,
        scale = p.scale or Unit.style.scale,
        rotate = p.rotate or Unit.style.rotate
    }
    self.children = {}
    local c = children or p.children
    if c then
        for k,v in pairs(c) do
            self:addChild(v)
            v:afterInit()
        end
    end
    if p.parent then Unit.addChild(p.parent, self) end
end
function Unit.panel:afterInit() end -- unused
function Unit.getPanelById(id) end -- unused

function Unit.panel:draw()
    pushMatrix() pushStyle()
    rectMode(self.drawMode)
    fill(self.style.fill)
    translate(self.rawFrame.x, self.rawFrame.y)
    scale(self.style.scale)
    rotate(self.style.rotate)
    rect(0, 0, self.rawFrame.w, self.rawFrame.h)
    if self.style.asset then
        spriteMode(self.drawMode)
        sprite(self.style.asset, 0, 0, self.rawFrame.w, self.rawFrame.h)
    end
    popStyle() popMatrix()
    for k,v in pairs(self.children) do
        v:draw()
    end
end

function Unit.panel:addChild(c)
    c.parent = self
    c.parentScreen = self.parentScreen
    table.insert(self.children, c)
    table.sort(self.children, function(a,b) return a.layer < b.layer end)
end

function Unit.panel:addParent(p) -- unused
    self.parent = p
    self.parentScreen = p.parentScreen
    table.insert(p.children, self)
    table.sort(p.children, function(a,b) return a.layer < b.layer end)
end

function Unit.panel:getCorners() -- very useful in hit methods
    local bl, tr
    if self.drawMode == CENTER then
        bl = vec2(self.rawFrame.x - self.rawFrame.w/2, self.rawFrame.y - self.rawFrame.h/2)
        tr = vec2(self.rawFrame.x + self.rawFrame.w/2, self.rawFrame.y + self.rawFrame.h/2)
    elseif self.drawMode == CORNERS then
        bl = vec2(self.rawFrame.x, self.rawFrame.y)
        tr = vec2(self.rawFrame.w, self.rawFrame.h)
    else
        bl = vec2(self.rawFrame.x, self.rawFrame.y)
        tr = vec2(self.rawFrame.x + self.rawFrame.w, self.rawFrame.y + self.rawFrame.h) 
    end
    return bl, tr
end
function Unit.panel:getBl()
    local bl
    if self.drawMode == CENTER then
        bl = vec2(self.rawFrame.x - self.rawFrame.w/2, self.rawFrame.y - self.rawFrame.h/2)
    elseif self.drawMode == CORNERS then
        bl = vec2(self.rawFrame.x, self.rawFrame.y)
    else
        bl = vec2(self.rawFrame.x, self.rawFrame.y)
    end
    return bl
end
function Unit.panel:getTr()
    local tr
    if self.drawMode == CENTER then
        tr = vec2(self.rawFrame.x + self.rawFrame.w/2, self.rawFrame.y + self.rawFrame.h/2)
    elseif self.drawMode == CORNERS then
        tr = vec2(self.rawFrame.w, self.rawFrame.h)
    else
        tr = vec2(self.rawFrame.x + self.rawFrame.w, self.rawFrame.y + self.rawFrame.h) 
    end
    return tr
end

function Unit.panel:sizeChanged(w, h) -- calls frame manager function on size change
    local test = self.frameManager(self, w, h)
    if not test then 
        error("Return value for "..self.name.."'s frameManager function is nil or false. Unable to verify soundness of function!")
    end
    for k,v in pairs(self.children) do
        v:sizeChanged(self.rawFrame.w, self.rawFrame.h)
    end
end


Unit.screen = class(Unit.panel)
-- A screen acts like a panel that is the width and height of the screen, and is a parent to all on-screen UI elements.
-- It is possible to define multiple screens and switch between them with the Unit.screen.set method.
-- Touch, draw, and sizeChanged functions are only called on the *current* screen to save resources.

function Unit.screen:init(panelp, children, settings)
    assert(panelp and children, "Error with screen parameters!")
    panelp.name = panelp.name or "screen"
    panelp.drawMode = CORNER
    panelp.frameManager = function()
        self.rawFrame = {x=0,y=0,w=WIDTH,h=HEIGHT}
        return true
    end
    self.parentScreen = self
    self.holdButtons = {}
    Unit.panel.init(self, panelp, children)
    self.touchers = Unit.tempBank
    Unit.tempBank = {}
    
    self:set() -- calls sizeChanged once after everything is initialized
end

function Unit.screen:set(transition) -- parameter does nothing… for now
    self:sizeChanged(WIDTH, HEIGHT)
    Unit.currentScreen = self
end


Unit.textPanel = class(Unit.panel) 
-- Here's a convenient, lightweight text panel. 
-- It doesn't use the more sophisticated abilities of the Unit.char or Unit.label classes.

function Unit.textPanel:init(p, children)
    Unit.panel.init(self, p, children)
    self.text = p.text or Unit.style.text
    self.font = p.font or Unit.style.font
    self.size = p.size or Unit.style.size
    self.align = p.align or Unit.style.align
    self.textFill = p.textFill or Unit.style.textFill
end

function Unit.textPanel:getTextPos()
    local bl, tr = self:getCorners()
    self.wrap = tr.x - bl.x
    if self.align == CENTER then
        self.textPos = vec2((tr.x-bl.x)/2+bl.x, (tr.y-bl.y)/2+bl.y)
    else
        self.textPos = vec2(bl.x, tr.y)
    end
    return self.textPos
end

function Unit.textPanel:sizeChanged(w,h)
    Unit.panel.sizeChanged(self, w, h)
    self:getTextPos()
end

function Unit.textPanel:draw()
    Unit.panel.draw(self)
    pushStyle()
    fill(self.textFill)
    textAlign(self.align)
    font(self.font)
    fontSize(self.size)
    textWrapWidth(self.wrap)
    if self.align == CENTER then
        textMode(CENTER)
    else
        textMode(CORNER)
    end
    text(self.text, self.textPos.x, self.textPos.y)
    popStyle()
end
