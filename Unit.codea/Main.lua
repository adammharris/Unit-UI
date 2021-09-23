-- Main.lua

--displayMode(FULLSCREEN_NO_BUTTONS)
function setup()
    Unit.help() -- Prints some introductory text.
    Unit.setup{markTouch=true, DEBUG=true}
end

function draw()
    Unit.draw()
end

-- Here are some optional global functions in case you want to customize them.
function sizeChanged(w, h) Unit.sizeChanged(w, h) end
function touched(touch) Unit.touched(touch) end
function hover(gesture) Unit.hover(gesture) end
function scroll(gesture) Unit.scroll(gesture) end
function keyboard(key) Unit.keyboard(key) end