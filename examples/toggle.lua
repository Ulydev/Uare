function love.load()
  
  font = love.graphics.newFont(48)
  
  button = uare.new({

    x = WWIDTH*.5-200,
    y = WHEIGHT*.5-200,

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

  local color = button.state == "active" and { 0, 255, 0 } or { 255, 0, 0 }
  love.graphics.setColor(color)
  love.graphics.circle("fill", WWIDTH*.5, WHEIGHT*.5, 25)
  
end

function love.textinput(t)
  myButton1.text.display = myButton1.text.display .. t
end