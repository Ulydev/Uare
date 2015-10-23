Uare
==============

A simple and customisable UI library for LÖVE

![image](http://zippy.gfycat.com/InformalCalculatingLcont.gif)

![image](http://zippy.gfycat.com/ScentedRipeEft.gif)

Setup
----------------

```lua
local uare = require "uare"

function love.update(dt)
  uare.updateUI(dt, love.mouse.getX(), love.mouse.getY())
end

function love.draw()
  uare.drawUI()
end
```

Usage
----------------

Create a simple button
```lua
myStyle = uare.new({

  width = 400,
  height = 60,
  
  --color
  
  color = {200, 200, 200},
  
  hoverColor = {150, 150, 150},
  
  holdColor = {100, 100, 100}

})
```

Uare uses a style system. This allows applying general styles to new buttons, removing the need to write unnecessary attributes on each uare.new().

Create styled buttons
```lua
myStyle = uare.newStyle({

  width = 400,
  height = 60,
  
  --color
  
  color = {200, 200, 200},
  
  hoverColor = {150, 150, 150},
  
  holdColor = {100, 100, 100},
  
  --border
  
  border = {
    color = {255, 255, 255},
  
    hoverColor = {200, 200, 200},
    
    holdColor = {150, 150, 150},
    
    size = 5
  },
  
  --text
  
  text = {
    color = {200, 0, 0},
    
    hoverColor = {150, 0, 0},
    
    holdColor = {255, 255, 255},
    
    font = love.graphics.newFont(48),
    
    align = "center",
    
    offset = {
      x = 0,
      y = -30
    }
  },

})

myButton1 = uare.new({
    
  text = {
    display = "button1"
  },
  x = 500,
  y = 100
  
}):style(myStyle) --apply general style

myButton2 = uare.new({
    
  text = {
    display = "button2"
  },
  x = 500,
  y = 200
  
}):style(myStyle)
```
Styles are created using uare.newStyle(attributes) and applied using uare.new(attributes):style(myStyle).
