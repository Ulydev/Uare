Uare
==============

A simple and customisable UI library for LÖVE

![image](http://zippy.gfycat.com/InformalCalculatingLcont.gif)

![image](http://zippy.gfycat.com/ScentedRipeEft.gif)

Setup
----------------

The first thing to do with Uare is, indeed, to require it.

```lua
local uare = require "uare"
```

Then, you'll need to update the library in order to update the status of your buttons, using uare.update(dt, mouseX, mouseY).

```lua
function love.update(dt)
  uare.update(dt, love.mouse.getX(), love.mouse.getY())
end
```

Lastly, you'll want to draw your buttons using uare.draw(). Alternatively, you can draw individual buttons using myButton:drawSelf().

```lua
function love.draw()
  uare.draw()
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

Uare uses a style system. This allows you to apply general styles to new buttons, removing the need to write unnecessary attributes on each uare.new().

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

Attributes
----------------

These are usable either in styles, or directly in new buttons. Button-specific attributes will not be overwritten by styles.
```lua
myStyle = uare.newStyle({
  text = {
    display = "Text",
    color = {255, 255, 255}
  }
})

myButton = uare.new({
  text = {
    display = "Button"
  }
}):style(myStyle)

--myButton will take the text.color attribute from myStyle, but will keep its own text.display ("Button")
```

General Attributes
```lua
x
y

width
height

color
hoverColor
holdColor
```

Border
```lua
border = {
  color
  hoverColor
  holdColor
  
  size
}
```

Text
```lua
text = {
  color
  hoverColor
  holdColor
  
  display --text to be shown
  font
  align
  
  offset = {
    x
    y
  }
}
```

Callbacks - Called on specific events
```lua
onClick --button is clicked down
onCleanRelease --button is cleanly released (mouse is inside the button)
onRelease --button is released (mouse _can_ be outside the button, for instance if the user tries to drag it)
onHold --button is held (called every frame)
onStartHover --mouse has started hovering the button
onHover --mouse is hovering the button (called every frame)
onReleaseHover --mouse is not hovering anymore
```

Callbacks can be set just like normal attributes.
```lua
myStyle = uare.newStyle({
  onClick = function() print("click!") end
})
```

Miscellaneous
----------------

```lua
button:remove()
```
Removes a specific button from Uare.

```lua
uare.clear()
```
Removes every button from Uare.
