function outsideDropdown(mx, my)
  return (mx <= WWIDTH*.5-200 or mx >= WWIDTH*.5+200 or my <= hoverMe.y or my >= drop2.y+drop2.height)
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

  dropdownIcon = uare.newIcon({
    type = "polygon",
    
    content = {
      {
        -10, -10,
        0, 0,
        10, -10
      }
    }
  })
  
  hoverMe = uare.new({
      
    text = {
      display = "hover me"
    },
    x = WWIDTH*.5-200,
    y = WHEIGHT*.5-200,
    
    icon = {
      source = dropdownIcon,
      color = {100, 100, 100},
      hoverColor = {255, 255, 255},
      offset = {
        x = 170,
        y = 6
      }
    },
    
    onHover = function()
      dropdownGroup:show(.5)
      dropdownGroup:enable()
    end,
    onReleaseHover = function()
      if outsideDropdown(love.mouse.getX(), love.mouse.getY()) then
        dropdownGroup:hide(.5)
        dropdownGroup:disable()
      end
    end
  }):style(myStyle) --apply general style

  dropdownGroup = uare.newGroup()
  
  dropbg = uare.new({
    color = {100, 100, 100},
    
    x = WWIDTH*.5-201,
    y = WHEIGHT*.5-140,
    
    width = 402,
    height = 166
  }):group(dropdownGroup)
  
  drop1 = uare.new({
      
    text = {
      display = "hello"
    },
    border = {
      size = 1
    },
    x = WWIDTH*.5-200,
    y = WHEIGHT*.5-100
  }):style(myStyle):group(dropdownGroup) --apply general style

  drop2 = uare.new({
      
    text = {
      display = "there"
    },
    border = {
      size = 1
    },
    x = WWIDTH*.5-200,
    y = WHEIGHT*.5-35
  }):style(myStyle):group(dropdownGroup) --apply general style

  hoverMe:toFront()
  dropdownGroup:hide()
  
end

function love.update(dt)
  
  local mx, my = love.mouse.getX(), love.mouse.getY()
  
  uare.update(dt, mx, my)
  
  if drop1:getActive() and outsideDropdown(mx, my) then --dropdown is active but not hovering anything
    dropdownGroup:hide(.5)
    dropdownGroup:disable()
  end
  
end

function love.draw()
  
  uare.draw()
  
end