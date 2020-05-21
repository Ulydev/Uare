io.stdout:setvbuf('no')

WWIDTH, WHEIGHT = 800, 600
love.window.setMode(WWIDTH, WHEIGHT)

local major,_,_,_ = love.getVersion()

COLOR_SCALE=1

if major >= 11 then
    COLOR_SCALE = 255
end


uare = require "uare"

--[[
Uncomment one of these to show different examples
--]]

require "examples.buttons"
--require "examples.windows"
--require "examples.content"
--require "examples.sliders"
--require "examples.joystick"
--require "examples.dropdown"
--require "examples.scroll"
--require "examples.toggle"
