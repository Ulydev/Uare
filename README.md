Uare
==============

A simple and customisable UI library for LÖVE

![image](http://zippy.gfycat.com/InformalCalculatingLcont.gif)

![image](http://zippy.gfycat.com/ScentedRipeEft.gif)

![image](https://i.gyazo.com/4b20ca8de45fcab3f4db76050f24fa15.gif)

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
They can also be applied *after* creation, using button:style(myStyle).

Icons
----------------

Icons can either represent polygons or images.

Create a new icon using uare.newIcon(), then link it to one or several buttons.

The content of a *polygon* icon is defined as a table containing one or more polygons.
```lua
closeIcon = uare.newIcon({
  type = "polygon",
  content = {
    {
      -6, -4,
      -4, -6,
      6, 4,
      4, 6
    },
    {
      6, -4,
      4, -6,
      -6, 4,
      -4, 6
    }
  }
})

imageIcon = uare.newIcon({
  type = "image",
  content = love.graphics.newImage("image.png"),
  offset = {
    x = 0,
    y = -16
  }
})
```

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

General Attributes - *attribute (default value)*

```lua
x
y

width
height

color
hoverColor
holdColor

drag (false)

active(true)
visible (true)

draw(true)
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
  display --text to be shown
  font
  align

  color
  hoverColor
  holdColor

  offset = {
    x
    y
  }
}
```

Icon
```lua
icon = {
  source
  
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

Anchors
----------------

A button can be anchored to another, which means it will follow its movement (in case of a draggable button, for instance). This is useful for making windows quickly, amongst other possible uses.

```lua
myDraggableButton = uare.new({
  drag = true
}):style(buttonStyle)

myFollowingButton = uare.new({}):style(buttonStyle):anchor(myDraggableButton) --this will follow myDraggableFollow
```

Indexes and priority order
----------------

Sometimes, you'll need to have a button overlaying another. This can be achieved using button:setIndex() or button:toFront().

You can also retrieve the index of a specific button with button:getIndex().

```lua
buttonfront = uare.new({}):style(buttonStyle)

buttonbehind = uare.new({}):style(buttonStyle) --buttonbehind is being draw on top of buttonfront

--from there, you can either do
buttonfront:toFront()

--or
buttonfront:setIndex(buttonbehind:getIndex() + 1)

--or
buttonbehind:setIndex(1)
buttonfront:setIndex(2)
```

Visibility and activity
----------------

Buttons can be enabled and disabled using button:setActive(bool), or button:enable() and button:disable().

When disabled, a button will still be updated but will ignore the mouse, making it idle.

Likewise, they can be shown and hidden using button:setVisible(bool, l), or button:show(l) and button:hide(l).

*l* is the *lerp* number (between 0 and 1). When specified, the element will fade at the desired rate, instead of appearing/disappearing brutally.

You can also retrieve the visibility and activity of a specific button with button:getActive() and button:getVisible().

```lua
myButton = uare.new({
  onClick = function()
    myButton:setVisible(not myButton:getVisible(), .2)
  end
}):style(buttonStyle)
```

Groups
----------------

Uare also uses a group system, which can be used to set attributes of many elements more efficiently.

```lua
myGroup = uare.newGroup() 

myButton1 = uare.new({}):style(buttonStyle):group(myGroup)
myButton2 = uare.new({}):style(buttonStyle):group(myGroup) --group those two buttons...

myGroup:hide() --...and hide them using a single line
```

Just like regular elements, *Groups* support some **methods** as well:
- group:setActive(), including
  - group:enable()
  - group:disable()
- group:setVisible(), including
  - group:show()
  - group:hide()
- group:setIndex(), including
  - group:toFront()

Removing elements
----------------

```lua
button:remove()
```
Removes a specific button from Uare.

```lua
uare.clear()
```

Removes every button from Uare.
