

local composer = require ("composer")

display.setStatusBar(display.HiddenStatusBar) 
-- You can make Composer store your variables by this method. 
-- Consider these, global variables that Composer stores for you. 
-- Later in the project, you can call use/change this variables.
-- It doesn't matter if it's a string or a number in Lua. I just named them like this for easier understanding.
-- Comment
composer.setVariable("variableString", "Game Level")
composer.setVariable("fontSize", 64)
composer.gotoScene("screens.logo", "crossFade", 500)