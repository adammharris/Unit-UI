-- Unit.lua

-- This tab contains the Unit table, setup function, and draw function, as well as multiple auxillary code pieces.
Unit = {
    version = 1.01,
    ticks = 0,
    screens = {},
    options = {},
    holdButtons = {},
    touches = {}
}
Unit.boolify = function(expression)
    local a = false
    if expression then a = true end
    return a
end

Unit.style = {
    frameManager = function(panel, w, h)
        local bl = panel.parent:getBl()
        panel.rawFrame.x = bl.x + w * panel.relativeFrame.x
        panel.rawFrame.y = bl.y + h * panel.relativeFrame.y
        panel.rawFrame.w = w * panel.relativeFrame.w
        panel.rawFrame.h = h * panel.relativeFrame.h
        return true 
    end,
    touchEvents = {function(toucher, currentHit, touch)
        if currentHit and touch.state == ENDED and toucher.captured == touch.id then 
            print(toucher.target.name.." was tapped!")
        end
    end},
    highlightTouchEvent = function(toucher, currentHit, touch)
        if (touch.state == ENDED or touch.state == CANCELLED or not currentHit) and toucher.captured == touch.id then
            toucher.target:highlight(false)
        elseif toucher.captured == touch.id then
            toucher.target:highlight(true)
        end
    end,
    layer = 1,
    name = "panel", drawMode = CENTER, tint = color(255),
    text = "", fill = color(0,0), stroke = color(0, 0), strokeWidth = 0, scale = 1, rotate = 0,
    relativeFrame = {x=0.5, y=0.5, w=0.2, h=0.2},
    font = "AmericanTypewriter", size = 17, textFill = color(64), align = CENTER
}

function Unit.setStyle(parameters)
    for k,v in pairs(parameters) do
        Unit.style[k] = v
    end
end

function Unit.setup(optionsTable)
    noSmooth()
    local ot = optionsTable or {}
    Unit.options = {
        DEBUG = ot.DEBUG,
        markTouch = ot.markTouch,
        drawMode = ot.drawMode or CENTER,
    }
    Unit.camera = { -- unused
        x = WIDTH/2,
        y = HEIGHT/2,
    }
    Unit.metrics = {
        enabled = Unit.options.DEBUG,
        updateTicks = 10,
        counter = 0,
        timeCounter = 0,
        fps = 0,
        memory = 0,
    }
    if Unit.options.DEBUG then
        parameter.watch("Unit.metrics.fps")
        parameter.watch("Unit.metrics.memory")
        parameter.watch("Unit.ticks")
        parameter.watch("ElapsedTime")
    end
    local thisScreen = Unit.currentScreen
    if Unit.defaultSetUp then Unit.defaultSetUp() end
    assert(Unit.currentScreen~=Unit.noScreen, "No screen defined!")
    assert(#Unit.currentScreen.touchers~=0, "The current screen has no touch-sensitive objects!")
    if thisScreen ~= Unit.noScreen and thisScreen ~= Unit.defaultScreen then thisScreen:set() end
end

function Unit.draw()
    Unit.currentScreen:draw()
    Unit.ticks = Unit.ticks + 1
    if Unit.metrics.enabled then
        Unit.metrics.counter = Unit.metrics.counter + 1
        Unit.metrics.timeCounter = Unit.metrics.timeCounter + DeltaTime
        if Unit.metrics.counter == Unit.metrics.updateTicks then 
            Unit.metrics.fps = (Unit.metrics.counter / Unit.metrics.timeCounter)
            Unit.metrics.memory = collectgarbage("count", 2)
            Unit.metrics.counter = 0
            Unit.metrics.timeCounter = 0
        end 
    end
    if Unit.options.markTouch then
        for _,v in pairs(Unit.touches) do
            pushStyle() fill(0, 50) strokeWidth(1) stroke(255) ellipse(v.x, v.y, 99, 99) ellipse(v.x, v.y, 9, 9) popStyle()
        end
    end
end

function Unit.touched(touch)
    Unit.touches[touch.id] = touch
    for k,t in ipairs(Unit.currentScreen.touchers) do t:touched(touch) end
    if touch.state == ENDED or touch.state == CANCELLED then Unit.touches[touch.id] = nil end
end
function Unit.sizeChanged(w, h) Unit.currentScreen:sizeChanged(w, h) end
function Unit.hover(gesture) for k,t in ipairs(Unit.currentScreen.touchers) do t:hover(touch) end end
function Unit.scroll(gesture) for k,t in ipairs(Unit.currentScreen.touchers) do t:scroll(touch) end end
function Unit.keyboard(key) end -- unused

Unit.helpString = [[
         ---------
         Unit Help
         ---------

Welcome to Unit!
Version: ]]..Unit.version..[[


Unit is a UI system for Codea that is designed to be powerful and easy to use, as well as easy on the device's resources.

To use Unit, call Unit.setup() in the setup function, and call Unit.draw() in the draw function. If you use the Unit template, they are already there for your convenience.

To see Unit from a developer's perspective, call Unit.setup{DEBUG=true} in the setup function. Unit.setup() can take several parameters in order to adjust Unit to your liking.

For further explanation, examine Unit's code closely.]]
function Unit.help() print(Unit.helpString) end