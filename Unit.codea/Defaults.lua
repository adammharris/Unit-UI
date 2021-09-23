-- Defaults.lua

-- The "Defaults" tab includes bits of code that are not vital to Unit, but may be useful.
-- Technically, you could delete this entire tab and run Unit entirely on custom functions.
-- However, you should only do that if you have very specific needs and know what you are doing.
--[
Unit.color = {
    invisible = color(0, 0, 0, 0),
    white = color(255, 255, 255, 255),
    grey = color(128), gray = color(128),
    lightgrey = color(196), lightgray = color(196),
    darkgrey = color(64), darkgray = color(64),
    black = color(0, 0, 0),
    red = color(255, 0, 0),
    green = color(0, 255, 0),
    blue = color(0, 0, 255),
    yellow = color(255, 255, 0),
    magenta = color(255, 0, 255),
    cyan = color(0, 255, 255),
    orange = color(255, 128, 0),
    pank = color(255, 0, 128),
    limegreen = color(128, 255, 0),
    violet = color(128, 0, 255),
    water = color(0, 128, 255),
    plum = color(128, 0, 128),
    darkcyan = color(0, 128, 128),
    olive = color(128, 128, 0),
    leaf = color(64, 192, 64),
    sky = color(64, 192, 255),
    cheese = color(255, 192, 64),
    maroon = color(158, 64, 64),
    purple = color(196, 64, 196),
    seagreen = color(64, 255, 196),
    lemonlime = color(196, 255, 64),
    pink = color(255, 64, 196),
    lightpink = color(255, 128, 196),
    coral = color(255, 196, 196),
    indigo = color(128, 64, 255),
}

table.transfer = function(receiver, giver)
    for k,v in pairs(giver) do
        receiver[k] = v
    end
end

Unit.defaultSetUp = function()
    local info = "Unit is currently showing you a demo, because you didn't define a screen."
    local infoBanner = Unit.textPanel({fill=color(0),textFill=color(255),w=1,y=0,h=0.1,x=0,layer=9,drawMode=CORNER,text=info})
    local myButton = Unit.button({asset=asset.builtin.UI.Blue_Button11,touchEvents={Unit.te.onTap(function() print"*hidden boop*" end)},highlight={asset=asset.builtin.UI.Blue_Button12}})
    local resetPos = function(s)
        s.parent.relativeFrame = {x=0.5,y=0.3,w=0.5,h=0.3}
        s.parent:sizeChanged(WIDTH,HEIGHT)
    end
    local backManager = function(customFrame)
        return function(panel, w, h)
            panel.rawFrame.x = customFrame.x
            panel.rawFrame.y = panel.parent.rawFrame.h - customFrame.y
            panel.rawFrame.w = customFrame.w or 100
            panel.rawFrame.h = customFrame.h or 100
            return true
        end
    end
    Unit.defaultScreen2 = Unit.screen({name="Unit.defaultScreen2", fill=Unit.color.leaf}, {
        Unit.button({text="Back",fill=Unit.color.sky,x=0.1,y=0.9,w=0.15,h=0.15,highlight={fill=Unit.color.black},
            frameManager=backManager{x=70,y=70},touchEvents={Unit.te.onTap(function()Unit.defaultScreen:set()end)}}),
        myButton, infoBanner
    })
    Unit.defaultScreen = Unit.screen({name="Unit.defaultScreen",fill=Unit.color.maroon}, {
        Unit.button({name="A",y=0.8, fill=Unit.color.white,highlight={fill=Unit.color.black},
            touchEvents={Unit.te.onTap(function()Unit.defaultScreen2:set()end)},text="Press me to change screens!"}),
        Unit.button({name="B",y=0.3,w=0.5,h=0.3,fill=Unit.color.seagreen,layer=5,touchEvents={Unit.te.draggable}}, {
            Unit.panel({name="D",drawMode=CORNER,y=0,x=0.1,h=1,fill=Unit.color.cheese}, {
                Unit.panel({name="Da",w=0.5,fill=Unit.color.darkgrey}, {
                    Unit.panel({name="Daa", fill=Unit.color.white})
                })
            }),
            Unit.panel{name="E",drawMode=CORNER,y=0.1,x=0.3,h=0.8,fill=Unit.color.magenta},
            Unit.panel{name="F",drawMode=CORNER,y=0,x=0.5,h=1,fill=Unit.color.sky},
            Unit.panel{name="G",drawMode=CORNER,y=0.1,x=0.7,h=0.8,fill=Unit.color.indigo},
            Unit.button{name="C",fill=Unit.color.purple,touchEvents={Unit.te.onTap(resetPos)}, 
                highlight={fill=Unit.color.plum},text="Reset"}
        }),
        infoBanner
    })
end
----------------------------------

Unit.fm = {}
-- Frame managers tell the panel what to do when the size of the screen changes.
-- It adjusts the "frame" of the panel, or the x coordinate, y coordinate, width, and height 
-- of the panel. The default frame manager changes every frame value according to
-- the size of the panel's parent. It is called once after init and again whenever
-- the screen is rotated. Only one frame manager is allowed per panel!

Unit.fm.default = function(customFrame)
    -- This one is actually a frame manager constructor, because
    -- it returns a custom frame manager function according to its parameters.
    local cf = customFrame or {} -- Allows for parts of frame to be fixed
    return function(panel, w, h)
        local bl = panel.parent:getBl()
        panel.rawFrame.x = cf.x or bl.x + w * panel.relativeFrame.x
        panel.rawFrame.y = cf.y or bl.y + h * panel.relativeFrame.y
        panel.rawFrame.w = cf.w or w * panel.relativeFrame.w
        panel.rawFrame.h = cf.h or h * panel.relativeFrame.h
        return true 
        -- If a frameManager function does not return anything, Unit will assume that something is wrong with it.
    end
end
Unit.fm.relative = function(customFrame)
    local cf = customFrame or {}
    return function(panel, w, h)
        local bl = panel.parent:getBl(w, h)
        panel.relativeFrame.x = cf.x or panel.relativeFrame.x
        panel.relativeFrame.y = cf.y or panel.relativeFrame.y
        panel.relativeFrame.w = cf.w or panel.relativeFrame.w
        panel.relativeFrame.h = cf.h or panel.relativeFrame.h
        panel.rawFrame.x = bl.x + w * panel.relativeFrame.x
        panel.rawFrame.y = bl.y + h * panel.relativeFrame.y
        panel.rawFrame.w = w * panel.relativeFrame.w
        panel.rawFrame.h = h * panel.relativeFrame.h
        return true
    end
end
Unit.fm.bl = function(customFrame)
    return function(panel, w, h)
        panel.rawFrame.x = customFrame.x
        panel.rawFrame.y = customFrame.y
        panel.rawFrame.w = customFrame.w or 100
        panel.rawFrame.h = customFrame.h or 100
        return true
    end
end
Unit.fm.tr = function(x, y)
    return function(panel, w, h)
        panel.rawFrame.x = panel.parent.rawFrame.w - customFrame.x
        panel.rawFrame.y = panel.parent.rawFrame.h - customFrame.y
        panel.rawFrame.w = customFrame.w or 100
        panel.rawFrame.h = customFrame.h or 100
        return true
    end
end
Unit.fm.br = function(customFrame)
    return function(panel, w, h)
        panel.rawFrame.x = panel.parent.rawFrame.w - customFrame.x
        panel.rawFrame.y = customFrame.y
        panel.rawFrame.w = customFrame.w or 100
        panel.rawFrame.h = customFrame.h or 100
        return true
    end
end
Unit.fm.tl = function(customFrame)
    return function(panel, w, h)
        panel.rawFrame.x = customFrame.x
        panel.rawFrame.y = panel.parent.rawFrame.h - customFrame.y
        panel.rawFrame.w = customFrame.w or 100
        panel.rawFrame.h = customFrame.h or 100
        return true
    end
end
Unit.fm.aspect = function(x, y, scale)
    return function(panel, w, h)
        -- unfinished
        return true
    end
end

Unit.nothing = function() end
--------------------------------------

Unit.te = {}
-- A touch event tells a button what to do when it is hit. It receives
-- three inputs: toucher, currentHit, and touch. currentHit is a boolean
-- primarily for efficiency and convenience. Through the toucher parameter
-- you can test whether the touch is "captured" or whether the target
-- meets certain requirements. One button can have multiple touch events.


Unit.te.onTap = function(custom)
    return function(toucher, currentHit, touch)
        if currentHit and touch.state == ENDED and toucher.captured == touch.id then
            if custom then 
                custom(toucher.target) else print(toucher.target.name.."\nmissing onTap function") 
            end
        end
    end
end

Unit.te.onDown = function(custom)
    return function(toucher, currentHit, touch)
        if currentHit and toucher.captured == touch.id then
            if custom then 
                custom(toucher.target) else print(toucher.target.name.."\nmissing onDown function") 
            end
        end
    end
end

Unit.te.onUp = function(custom)
    return function(toucher, currentHit, touch)
        if currentHit and touch.state == ENDED or touch.state == CANCELLED then
            if custom then 
                custom(toucher.target) else print(toucher.target.name.."\nmissing onUp function") 
            end
        end
    end
end

Unit.te.nudge = function(customFunc, customBound) -- bugly
    return function(toucher, currentHit, touch)
        local b = customBound or function() return true end
        local p = toucher.target
        local w = toucher.target.parentScreen.rawFrame.w
        local h = toucher.target.parentScreen.rawFrame.h
        if currentHit and b(p) then
            local newPos = vec2(p.rawFrame.x + touch.delta.x, p.rawFrame.y + touch.delta.y)
            if newPos.x > p.rawFrame.w/2 and newPos.x < w-p.rawFrame.w/2 then p.rawFrame.x = newPos.x end
            if newPos.y > p.rawFrame.h/2 and newPos.y < h-p.rawFrame.h/2 then p.rawFrame.y = newPos.y end
            if custom then custom(toucher.target) end
        end
        if touch.state == ENDED then
            toucher.target.relativeFrame.x = toucher.target.rawFrame.x/w
            toucher.target.relativeFrame.y = toucher.target.rawFrame.y/h
        end
    end
end

Unit.te.draggable = function(toucher, currentHit, touch) -- not compatible with multiple drawModes!
    local p = toucher.target
    if currentHit and toucher.captured == touch.id then
        local newPos = vec2(p.rawFrame.x + touch.delta.x, p.rawFrame.y + touch.delta.y)
        if newPos.x > p.rawFrame.w/2 and newPos.x < WIDTH-p.rawFrame.w/2 then p.rawFrame.x = newPos.x end
        if newPos.y > p.rawFrame.h/2 and newPos.y < HEIGHT-p.rawFrame.h/2 then p.rawFrame.y = newPos.y end
        for k,v in pairs(p.children) do
            v:sizeChanged(p.rawFrame.w, p.rawFrame.h)
        end
        if p.label then 
            local bl, tr = p:getCorners()
            p.label.x = bl.x
            p.label.y = tr.y - p.label.size
            p.label:sizeChanged(tr.x - bl.x, tr.y - bl.y)
        end
    end
    if touch.state == ENDED or touch.state == CANCELLED then
        toucher.target.relativeFrame.x = toucher.target.rawFrame.x/WIDTH
        toucher.target.relativeFrame.y = toucher.target.rawFrame.y/HEIGHT
    end
end
--]]