-- Main.lua
-- This is a sample starting point for a project.

--displayMode(FULLSCREEN_NO_BUTTONS)

--[[ 
-- This screen definition will not work because Unit isn't defined yet.
-- Copy + paste this into a project that uses Unit as a dependency to see what it does.
-- Without any screen, Unit will show a default screen which you can find in Defaults.lua
titleScreen = Unit.screen({fill=Unit.color.sky}, {
    Unit.textPanel({fill=color(255), text="Menu", y=0.9, w=1,size=30,stroke=Unit.color.sky,strokeWidth=9}),
    Unit.panel({fill=color(83, 156, 224),w=1,x=0,y=0,h=0.2,drawMode=CORNER},{
        Unit.button({x=0.25,h=0.5,text="Info",fill=color(255),
            touchEvents={Unit.te.onTap(function() end)}}),
        Unit.button({h=0.5,text="Start",fill=color(255),
            touchEvents={Unit.te.onTap(function() end)}}),
        Unit.button({x=0.75,h=0.5,text="Options",fill=color(255),
            touchEvents={Unit.te.onTap(function() end)}})
    }),
})
]]

function setup()
    Unit.setup{markTouch=true, DEBUG=true}
end

function draw()
    Unit.draw()
end

function sizeChanged(w, h) Unit.sizeChanged(w, h) end
function touched(touch) Unit.touched(touch) end
function hover(gesture) Unit.hover(gesture) end
function scroll(gesture) Unit.scroll(gesture) end
function keyboard(key) Unit.keyboard(key) end
