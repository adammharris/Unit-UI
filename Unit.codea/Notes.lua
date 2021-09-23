-- Notes.lua

-- Feel free to delete this tab. There's no code.

--[[
Unit
Version 1.01
©️ Adam Harris 2020

Version History:
1.0 - First release. Modular size changing and touch handling implemented along with panel, toucher, and button class.
1.0.1 - July 6, 2020. Bug fixes. Unit.style table to provide default values. Also added more frame managers in Defaults tab.

Last updated: 
July 6, 2020

Description: 
Unit is a highly customizable UI system for Codea. 
Its primary aim is to reduce the distance between a Codea user and a good UI. Things that increase this distance are glitches, inefficiency, and inaccessibility. Things that decrease this distance are flexibility, self-explanatory design, and power. Unit goes to great lengths to fulfill these requirements in every possible way.
Every class in Unit with a draw method, that is, every class a programmer needs to work with when using Unit, has only two parameters. One of these is a parameter table, and the other one is an optional children table. The parameter table allows every needed value to be set with default values. The children table allows an entire tree to be defined in a single variable. If you desire, parent/children hierarchies can be handled automatically through the nesting of tables of initialization functions, though manual defining of parents and children is also supported.
Every leaf of a hierarchy uses a "frame manager" function to handle changing between portrait and landscape orientations. By default, the frame (x, y, w, h) of any Unit.panel is equal to the values of its "relativeFrame" multiplied by the values of its parent's frame. A Unit.panel's relativeFrame is typically a table of percentages that are defined upon initialization. But if you want, you can switch out this default frame manager function with an entirely different one. You could use one of the many provided function constructors in the Unit.fm table, or you can make a function of your own to make sure it suits your needs exactly.
Another customizable feature of Unit is touch events. The Unit.button class can take a "touchEvents" parameter, which is assumed to be an indexed table of functions. Each function is called in the order they are provided upon being hit. Again, each of these functions can be totally original, or made from a function constructor in the Unit.te table.
At this point, Unit is only in its first version. Its functionality is limited, and it could be improved in many areas. In short, it doesn't live up to its high expectations yet, but it will with time.

To do's:
- Better touch interception.
    - Right now, layers are the primary means of interception. Too simple.
- Better text. Text editing.
- Sliders, toggles, windows, and so forth.
- Rounded rectangles
- Mesh backgrounds
]]