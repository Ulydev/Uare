function math.lerp(a, b, k) --just fun stuff
  if a == b then return a else
    if math.abs(a-b) < 0.005 then return b else return a * (1-k) + b * k end
  end
end

function love.load()
  
  font = love.graphics.newFont(48)
  
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
      
      font = font,
      
      align = "center",
      
      offset = {
        x = 0,
        y = -30
      }
    },

  })
  
  myButton1 = uare.new({
      
    text = {
      display = "button"
    },
    x = WWIDTH*.5-200,
    y = WHEIGHT*.5-200
  }):style(myStyle) --apply general style

  myButton2 = uare.new({
      
    text = {
      display = "hover"
    },
    x = WWIDTH*.5-200,
    y = WHEIGHT*.5-80,
    
    width = 180
    
  }):style(myStyle)

  myButton3 = uare.new({
      
    text = {
      display = "click"
    },
    x = WWIDTH*.5+20,
    y = WHEIGHT*.5-80,
    
    width = 180,
    
    onClick = function() myButton3.y = myButton3.y+2 end,
    onRelease = function() myButton3.y = myButton3.y-2 end
    
  }):style(myStyle)

  myButton4 = uare.new({
      
    text = {
      display = "shake"
    },
    x = WWIDTH*.5-200,
    y = WHEIGHT*.5+40
    
  }):style(myStyle)

  myButton5 = uare.new({
      
    text = {
      display = "grow"
    },
    x = WWIDTH*.5+200,
    y = WHEIGHT*.5+160
    
  }):style(myStyle)

  myButton6 = uare.new({
      
    text = {
      display = "slide"
    },
    x = -160,
    y = WHEIGHT*.5+40,
    
    width = 180
    
  }):style(myStyle)
  
end

function love.update(dt)
  
  uare.update(dt, love.mouse.getX(), love.mouse.getY())
  
  --little animations
  myButton2.height = math.lerp(myButton2.height, myButton2.hover and 70 or 60, .2)
  myButton2.y = WHEIGHT*.5-80-myButton2.height*.5+30
  
  myButton4.text.offset.x = math.lerp(myButton4.text.offset.x, myButton4.hover and (math.sin(love.timer.getTime()*20))*20 or 0, .1)
  
  myButton5.width = math.lerp(myButton5.width, myButton5.hover and 460 or 400, .1)
  myButton5.height = math.lerp(myButton5.height, myButton5.hover and 70 or 60, .1)
  
  myButton5.x = WWIDTH*.5-myButton5.width*.5
  
  myButton6.x = math.lerp(myButton6.x, myButton6.hover and -20 or -160, .2)
  
end

function love.draw()
  
  uare.draw()
  
end

function love.textinput(t)
  myButton1.text.display = myButton1.text.display .. t
end