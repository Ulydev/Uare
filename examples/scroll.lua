function createWindow(x, y, w, h)
  local group = uare.newGroup()

  local top = uare.new({
    x = x,
    y = y,
    width = w,
    height = 30,
    
    drag = {
      enabled = true
    },
    
    color = {160, 160, 160},
    hoverColor = {140, 140, 140},
    holdColor = {120, 120, 120},
    
    text = {
      display = "sample text",
      align = "center",
      
      font = love.graphics.newFont(28),
      
      offset = {
        x = -4,
        y = -16
      },
      
      color = {255, 255, 255},
    },
    
    onClick = function() group:toFront() end,
  }):group(group):style(borderStyle)

  local frame = uare.new({
    x = x,
    y = y+30,
    
    width = w,
    height = h,
    
    color = {255, 255, 255},
    
    content = {
      wrap = true,
      width = 250,
      height = 500
    }

  }):anchor(top):group(group):style(borderStyle)

  return {top = top, close = close, frame = frame, group = group, slider = slider}
end

function drawLargeStuff(ref, alpha)

  love.graphics.setColor(255, 255, 255, alpha)
  love.graphics.draw(image, 20, 60, 0, .4, .4)
  love.graphics.draw(image, 200, 60, 0, .4, .4) --cut
  
end

function love.load()
  
  font = love.graphics.newFont(48)
  
  borderStyle = uare.newStyle({
    border = {
      color = {100, 100, 100},
      size = 2
    }  
  })

  image = love.graphics.newImage("examples/image.png")
  
  window1 = createWindow(100, 50, 250, 300)
  
  window1.sliderBackground = uare.new({ --this is totally optional - just for visual purposes
    x = window1.top.x+229,
    y = window1.top.y+30,
    
    width = 21,
    height = window1.frame.height,
    
    active = false,
      
    color = {120, 120, 120, 150},
  }):anchor(window1.top):group(window1.group)

  window1.slider = uare.new({
    x = window1.top.x+230,
    y = window1.top.y+30,
    
    width = 20,
    height = 100,
    
    color = {160, 160, 160},
    hoverColor = {140, 140, 140},
    holdColor = {120, 120, 120},
    
    drag = {
      enabled = true,
      fixed = {
        x = true,
        y = false
      },
      bounds = {
        {
          y = window1.top.y+30
        },
        {
          y = window1.top.y+230 --frame bottom minus slider's height
        }
      }
    }
  }):anchor(window1.top):group(window1.group):style(borderStyle)

  window2 = createWindow(100, 400, 500, 150)
  
  window2.sliderBackground = uare.new({
    x = window2.top.x,
    y = window2.top.y+window2.frame.height+9,
    
    width = window2.frame.width,
    height = 21,
    
    active = false,
      
    color = {120, 120, 120, 150},
  }):anchor(window2.top):group(window2.group)

  window2.slider = uare.new({
    x = window2.top.x,
    y = window2.top.y+window2.frame.height+10,
    
    width = 100,
    height = 20,
    
    color = {160, 160, 160},
    hoverColor = {140, 140, 140},
    holdColor = {120, 120, 120},
    
    drag = {
      enabled = true,
      fixed = {
        x = false,
        y = true
      },
      bounds = {
        {
          x = window2.top.x
        },
        {
          x = window2.top.x+window2.top.width-100
        }
      }
    }
  }):anchor(window2.top):group(window2.group):style(borderStyle)

  window2.frame:setContentDimensions(600, 150)
  
  window1.frame:setContent(drawLargeStuff)
  window2.frame:setContent(drawLargeStuff)
  
end

function love.update(dt)
  
  uare.update(dt, love.mouse.getX(), love.mouse.getY())

  window1.slider:setDragBounds({ --adapt slider to anchor
    { y = window1.top.y+30 },
    { y = window1.top.y+230 }
  })
  
  window1.frame:setScroll({ y = window1.slider:getVerticalRange()})
  
  window2.slider:setDragBounds({ --adapt slider to anchor
    { x = window2.top.x },
    { x = window2.top.x+window2.top.width-100 }
  })
  
  window2.frame:setScroll({ x = window2.slider:getHorizontalRange()})
  
end

function love.draw()
  
  uare.draw()
  
end