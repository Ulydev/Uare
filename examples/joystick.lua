function love.load()
  
  --default style for the big button
  
  joystick = uare.new({

    x = WWIDTH*.5-25,
    y = WHEIGHT*.8-25,

    width = 50,
    height = 50,
    
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
    
    drag = {
      enabled = true,
      bounds = {
        {
          x = WWIDTH*.5-50,
          y = WHEIGHT*.8-50
        },
        {
          x = WWIDTH*.5,
          y = WHEIGHT*.8
        }
      }
    }

  })

  sliderBackground = uare.new({
    x = WWIDTH*.8,
    y = WHEIGHT*.8,
      
    width = 100,
    height = 40,
    
    color = {100, 100, 100},
    
    center = true,
    
    text = {
      font = love.graphics.newFont(24),
      color = {255, 255, 255},
      align = "center",
      offset = {
        x = 0,
        y = 32
      }
    }
  })

  speedSlider = uare.new({
      
    x = WWIDTH*.8,
    y = WHEIGHT*.8,
      
    height = 50,
    width = 30,
    
    color = {255, 255, 255},
    
    hoverColor = {200, 200, 200},
    
    center = true, --makes positioning easier!
      
    drag = {
      enabled = true,
      fixed = {
        x = false, --move only on the X axis
        y = true
      },
      bounds = {
        {
          x = WWIDTH*.8-50
        },
        {
          x = WWIDTH*.8+50
        }
      }
    }
  })

  player = {x = WWIDTH*.5, y = WHEIGHT*.5}
  
end

function love.update(dt)
  
  local mx, my = love.mouse.getX(), love.mouse.getY()
  
  uare.update(dt, mx, my)
  
  if not joystick.hold then
    joystick.x, joystick.y = WWIDTH*.5-25, WHEIGHT*.8-25 --we released the joystick
  end
  
  local velocity = {x = (joystick:getHorizontalRange()-.5)*2, y = (joystick:getVerticalRange()-.5)*2}
  
  velocity.magnitude = math.sqrt(velocity.x^2 + velocity.y^2)
  
  if velocity.magnitude > 1 then --requires a *bit* of tweaking to get a nice joystick feel, else it acts as a normal square
    
    mx, my = mx+joystick.width*.5+uare.holdt.d.x, my+joystick.height*.5+uare.holdt.d.y --take difference between mouse and center of joystick in account
    
    local angle = math.atan2(my-WHEIGHT*.8, mx-WWIDTH*.5) --get the current angle of center<->mouse...
    
    joystick.x = WWIDTH*.5-25+math.cos(angle)*25
    joystick.y = WHEIGHT*.8-25+math.sin(angle)*25 --and wrap it in an invisible 25px circle
    
    velocity.x, velocity.y = math.cos(angle), math.sin(angle) --then, recalculate the velocity according to that angle
    
  end
  
  --are you still alive?
  
  player.speed = speedSlider:getHorizontalRange()*1000
  
  sliderBackground.text.display = "speed: "..player.speed
  
  player.x, player.y = player.x+player.speed*velocity.x*dt, player.y+player.speed*velocity.y*dt
  
  if player.x < 20 then player.x = 20 elseif player.x > WWIDTH-20 then player.x = WWIDTH-20 end
  if player.y < 20 then player.y = 20 elseif player.y > WHEIGHT*.7-20 then player.y = WHEIGHT*.7-20 end
  
end

function love.draw()

  love.graphics.setColor(100, 100, 100)
  love.graphics.circle("fill", WWIDTH*.5, WHEIGHT*.8, 50)
  
  uare.draw()
  
  love.graphics.setColor(255, 255, 255)
  love.graphics.circle("fill", player.x, player.y, 20)
  
end