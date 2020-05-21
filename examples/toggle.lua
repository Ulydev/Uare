function love.load()
  
  font = love.graphics.newFont(48)
  
  button = uare.new({

    x = WWIDTH*.5-200,
    y = WHEIGHT*.5-200,

    width = 400,
    height = 60,
    
    --color
    
    color = {200/COLOR_SCALE, 200/COLOR_SCALE, 200/COLOR_SCALE},
    
    hoverColor = {150/COLOR_SCALE, 150/COLOR_SCALE, 150/COLOR_SCALE},
    
    holdColor = {100/COLOR_SCALE, 100/COLOR_SCALE, 100/COLOR_SCALE},
    
    --border
    
    border = {
      color = {255/COLOR_SCALE, 255/COLOR_SCALE, 255/COLOR_SCALE},
    
      hoverColor = {200/COLOR_SCALE, 200/COLOR_SCALE, 200/COLOR_SCALE},
      
      holdColor = {150/COLOR_SCALE, 150/COLOR_SCALE, 150/COLOR_SCALE},
      
      size = 5
    },
    
    --text
    
    text = {
      color = {200/COLOR_SCALE, 0/COLOR_SCALE, 0/COLOR_SCALE},
      
      hoverColor = {150/COLOR_SCALE, 0/COLOR_SCALE, 0/COLOR_SCALE},
      
      holdColor = {255/COLOR_SCALE, 255/COLOR_SCALE, 255/COLOR_SCALE},
      
      font = font,
      
      align = "center",
      
      offset = {
        x = 0,
        y = -30
      }
    },

  })

  --set up initial state
  button.state = "inactive"
  button.text.display = button.state

  button.onRelease = function ()
    button.state = button.state == "inactive" and "active" or "inactive"
    button.text.display = button.state
  end
  
end

function love.update(dt)
  
  uare.update(dt, love.mouse.getX(), love.mouse.getY())

end

function love.draw()
  
  uare.draw()

  local color = button.state == "active" and { 0/COLOR_SCALE, 255/COLOR_SCALE, 0/COLOR_SCALE } or { 255/COLOR_SCALE, 0/COLOR_SCALE, 0/COLOR_SCALE }
  love.graphics.setColor(color)
  love.graphics.circle("fill", WWIDTH*.5, WHEIGHT*.5, 25)
  
end

function love.textinput(t)
  button.text.display = button.text.display .. t
end
