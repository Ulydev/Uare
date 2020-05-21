function love.load()
  
  --default style for the big button
  
  myStyle = uare.newStyle({

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
      
      font = love.graphics.newFont(48),
      
      align = "center",
      
      offset = {
        x = 0,
        y = -30
      }
    },

  })
  
  --create style for sliders
  
  sliderStyle = uare.newStyle({
    height = 40,
    width = 30,
      
    drag = {
      enabled = true,
      fixed = {
        x = false, --move only on the X axis
        y = true
      },
      bounds = {
        {
          x = WWIDTH*.5-115
        },
        {
          x = WWIDTH*.5+85
        }
      }
    }
  })

  --then for slider backgrounds

  sliderBackgroundStyle = uare.newStyle({
    width = 200,
    height = 40,
    
    color = {100/COLOR_SCALE, 100/COLOR_SCALE, 100/COLOR_SCALE},
    
    text = {
      font = love.graphics.newFont(24),
      color = {255/COLOR_SCALE, 255/COLOR_SCALE, 255/COLOR_SCALE},
      align = "center",
      offset = {
        x = 200,
        y = -16
      }
    }
  })

  bgR = uare.new({
    x = WWIDTH*.5-100,
    y = WHEIGHT*.6
  }):style(sliderBackgroundStyle)

  bgG = uare.new({
    x = WWIDTH*.5-100,
    y = WHEIGHT*.7
  }):style(sliderBackgroundStyle)

  bgB = uare.new({
    x = WWIDTH*.5-100,
    y = WHEIGHT*.8
  }):style(sliderBackgroundStyle)

  sliderR = uare.new({
    x = WWIDTH*.5-15,
    y = WHEIGHT*.6
  }):style(sliderStyle):style(myStyle)

  sliderG = uare.new({
    x = WWIDTH*.5-15,
    y = WHEIGHT*.7
  }):style(sliderStyle):style(myStyle)

  sliderB = uare.new({
    x = WWIDTH*.5-15,
    y = WHEIGHT*.8
  }):style(sliderStyle):style(myStyle)

  button = uare.new({
    x = WWIDTH*.5-150,
    y = WHEIGHT*.2,
    
    width = 300,
    height = 200,
    
    color = {128/COLOR_SCALE, 128/COLOR_SCALE, 128/COLOR_SCALE},
    
    text = {
      display = "Reset"
    },
    
    onCleanRelease = function()
      local initialX = WWIDTH*.5-15
      sliderR.x, sliderG.x, sliderB.x = initialX, initialX, initialX
    end
    
  }):style(myStyle)
  
end

function love.update(dt)
  
  uare.update(dt, love.mouse.getX(), love.mouse.getY())
  
  local r = sliderR:getHorizontalRange()*255/COLOR_SCALE --value returned is between 0 and 1
  local g = sliderG:getHorizontalRange()*255/COLOR_SCALE
  local b = sliderB:getHorizontalRange()*255/COLOR_SCALE
  
  bgR.text.display, bgG.text.display, bgB.text.display = r, g, b
  
  button.color = {r, g, b}
  
end

function love.draw()
  
  uare.draw()
  
end
