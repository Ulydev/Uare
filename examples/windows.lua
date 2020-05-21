function createWindow(x, y)
  local group = uare.newGroup()

  local top = uare.new({
    x = x,
    y = y,
    width = 250,
    height = 30,
    
    drag = {
      enabled = true
    },
    
    color = {160/COLOR_SCALE, 160/COLOR_SCALE, 160/COLOR_SCALE},
    hoverColor = {140/COLOR_SCALE, 140/COLOR_SCALE, 140/COLOR_SCALE},
    
    text = {
      display = "sample text",
      
      font = love.graphics.newFont(28),
      
      offset = {
        x = 16,
        y = -16
      },
      
      color = {255, 255, 255},
    },
    
    onClick = function() group:toFront() end,
  }):group(group):style(borderStyle)

  local close = uare.new({
    x = x+200,
    y = y,
    
    width = 50,
    height = 30,
    
    color = {200/COLOR_SCALE, 200/COLOR_SCALE, 200/COLOR_SCALE},
    hoverColor = {200/COLOR_SCALE, 180/COLOR_SCALE, 180/COLOR_SCALE},
    holdColor = {200/COLOR_SCALE, 160/COLOR_SCALE, 160/COLOR_SCALE},
    
    icon = {
      source = closeIcon,
      
      color = {220/COLOR_SCALE, 0/COLOR_SCALE, 0/COLOR_SCALE},

      hoverColor = {250/COLOR_SCALE, 0/COLOR_SCALE, 0/COLOR_SCALE},

      holdColor = {150/COLOR_SCALE, 0/COLOR_SCALE, 0/COLOR_SCALE},

    },
  
    onCleanRelease = function() group:setActive(false) group:setVisible(false, .5) end,
  
  }):anchor(top):group(group):style(borderStyle)

  local content = uare.new({
    x = x,
    y = y+30,
    
    width = 250,
    height = 300,
    
    color = {255/COLOR_SCALE, 255/COLOR_SCALE, 255/COLOR_SCALE},

  }):anchor(top):group(group):style(borderStyle)

  return {top = top, close = close, content = content, group = group}
end

function love.load()
  
  font = love.graphics.newFont(48)
  
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
  
  borderStyle = uare.newStyle({
    border = {
      color = {100/COLOR_SCALE, 100/COLOR_SCALE, 100/COLOR_SCALE},
      size = 2
    }  
  })
  
  windows = {}
  for i = 1, 10 do
    windows[i] = createWindow(i*50, i*18)
  end
  
  open = uare.new({
    
    x = WWIDTH*.5-200,
    y = WHEIGHT-80,
    width = 400,
    height = 60,
    color = {0/COLOR_SCALE, 0/COLOR_SCALE, 0/COLOR_SCALE},
    hoverColor = {100/COLOR_SCALE, 100/COLOR_SCALE, 100/COLOR_SCALE},
    holdColor = {100/COLOR_SCALE, 0/COLOR_SCALE, 0/COLOR_SCALE},
    
    border = {
      color = {255/COLOR_SCALE, 255/COLOR_SCALE, 255/COLOR_SCALE},
      size = 5
    },
    
    text = {
      display = "open all windows",
      font = love.graphics.newFont(32),
      color = {255/COLOR_SCALE, 255/COLOR_SCALE, 255/COLOR_SCALE},
      align = "center",
      offset = {
        x = 0,
        y = -20
      }
    },
    
    onCleanRelease = function() for i = 1, #windows do windows[i].group:show() windows[i].group:enable() end end,
  })
  
end

function love.update(dt)
  
  uare.update(dt, love.mouse.getX(), love.mouse.getY())
  
  open:toFront()
  
end

function love.draw()
  
  uare.draw()
  
end

