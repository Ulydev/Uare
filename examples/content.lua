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
    
    width = 250,
    height = 300,
    
    color = {255, 255, 255},
    
    content = {
      wrap = true,
      bounds = {
        {
          x = 0,
          y = 0
        },
        {
          x = 400,
          y = 500
        }
      }
    }

  }):anchor(top):group(group):style(borderStyle)

  return {top = top, close = close, frame = frame, group = group}
end

function drawStuff()
  --origin is top-left corner of window
  love.graphics.setColor(200, 0, 0)
  love.graphics.circle("fill", 40, 40, 20)
  love.graphics.circle("fill", 240, 40, 20) --wrapped inside window
  love.graphics.setLineWidth(5)
  love.graphics.line(20, 100, 120, 150, 20, 150)
  love.graphics.line(200, 100, 300, 150, 200, 150) --cut
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(image, 20, 170, 0, .4, .4)
  love.graphics.draw(image, 200, 170, 0, .4, .4) --cut
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
  
  window1 = createWindow(100, 50)
  
  window2 = createWindow(450, 50)
  window2.frame.content.wrap = false
  
end

function love.update(dt)
  
  uare.update(dt, love.mouse.getX(), love.mouse.getY())
  
end

function love.draw()
  
  window1.frame:setContent(drawStuff)
  window2.frame:setContent(drawStuff)
  
  uare.draw()
  
end