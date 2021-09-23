-- Toucher.lua

-- This tab contains the Unit.toucher class, which is used to make touch handlers.
-- The main Unit.toucher.touched method simply passes touches to the toucher's events.
-- Built-in touch events can be found in Defaults.lua

Unit.toucher = class()
Unit.tempBank = {} -- Used to bypass the need to access the incompletely initialized parentScreen.
-- Probably a better way to do all this

function Unit.addToucher(target, events, priority, share)
    local t = Unit.toucher(target, events, priority, share)
    table.insert(Unit.tempBank, t)
    table.sort(Unit.tempBank, function(a,b) return a.priority < b.priority end)
    return t
end

function Unit.toucher:init(target, events, priority, share)
    assert(target and events and priority)
    self.target = target
    self.priority = priority
    self.captured = 1
    self.touches = {}
    self.events = events 
    self.enabled = true
    self.share = share
    --print(share)
    if not self.share then self.share = false end
end

function Unit.toucher:touched(touch)
    if not self.enabled then return end
    local currentHit = self.target:hit(vec2(touch.x, touch.y))
    if touch.state == BEGAN then 
        if currentHit then 
            self.captured = touch.id
            self.touches[touch.id] = true
        end
    end
    if self.target.children then -- If child is hit as well, touch only the child (that sounds weird out of context)
        for k,v in pairs(self.target.children) do
            if v.hit then if v:hit(touch) then return end end
        end 
    end
    for k,v in pairs(self.target.parent.children) do
        if v.hit then if v:hit(touch) and v.layer > self.target.layer then return end end
    end
    self.target.highlightTouchEvent(self, currentHit, touch)
    if self.captured == touch.id then self.target.isHeld = currentHit end
    for k,event in ipairs(self.events) do event(self, currentHit, touch) end
    if touch.state == ENDED or touch.state == CANCELLED then
        if self.captured == touch.id then self.target.isHeld = false end
        self.touches[touch.id] = nil
    end
    --print(self.share)
    if self.share and currentHit and self.captured == touch.id then
        for _,v in pairs(Unit.currentScreen.touchers) do
            if v.priority == self.priority then
                v.captured = touch.id
                v.touches[touch.id] = true
            end
        end
    end
end

function Unit.toucher:scroll(gesture) if self.target.hover then self.target:scroll(gesture) end end
function Unit.toucher:hover(gesture) if self.target.hover then self.target:hover(gesture) end end
-- The above two functions are just placeholders for now


