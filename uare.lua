-- uare.lua v0.1

-- Copyright (c) 2015 Ulysse Ramage
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

--[[

button = uare.new({
  color = {255, 255, 255},
  hoverColor = {255, 255, 255},
})

--]]

local uare = {name = "Uare", buttons = {}}
uare.__index = uare

-- Private

local uareMt = {__index = uare}
--local abs, min, max = math.abs, math.min, math.max

local function withinBounds(x, y, x1, y1, x2, y2)
  return x > x1 and x < x2 and y > y1 and y < y2
end

local function mergeTables(t1, t2, overwrite)
  for k,v in pairs(t2) do
    if type(v) == "table" then
      if type(t1[k] or false) == "table" then
        mergeTables(t1[k] or {}, t2[k] or {}, overwrite)
      else
        if not t1[k] or overwrite then t1[k] = v end
      end
    else
      if not t1[k] or overwrite then t1[k] = v end
    end
  end
  return t1
end

local function copyTable(object)
  local lookup_table = {}
  local function _copy(object)
      if type(object) ~= "table" then
          return object
      elseif lookup_table[object] then
          return lookup_table[object]
      end
      local new_table = {}
      lookup_table[object] = new_table
      for index, value in pairs(object) do
          new_table[_copy(index)] = _copy(value)
      end
      return setmetatable(new_table, getmetatable(object))
  end
  return _copy(object)
end

-- Public methods

function uare.new(f)

  local uareObj = f
  setmetatable(uareObj, uare)
  
  uareObj.hover, uareObj.click = false, false

  table.insert(uare.buttons, uareObj)
  
  return uareObj
end

function uare.newStyle(f) return f end

function uare:update(dt, mx, my, e)
  
  local mlc = love.mouse.isDown("l")

  local wb = withinBounds(mx, my, self.x, self.y, self.x+self.width, self.y+self.height)
  
  local thover, thold = self.hover, self.hold
  
  self.hover = wb
  
  self.hold = ((e == "c" and wb) and true) or (mlc and self.hold) or ((wb and e ~= "r" and self.hold))
  
  if e == "c" and wb and self.onClick then --clicked
    self.onClick()
  elseif (e == "r" and wb and thold) and self.onCleanRelease then
    self.onCleanRelease()
  elseif ((e == "r" and wb and thold) or (self.hold and not wb)) and self.onRelease then --released (or mouse has left button, still holding temporarly)
    self.onRelease()
  elseif self.hold and self.onHold then --holding
    self.onHold()
  elseif not thover and self.hover and self.onStartHover then --started hovering
    self.onStartHover()
  elseif self.hover and self.onHover then --hovering
    self.onHover()
  elseif thover and not self.hover and self.onReleaseHover then --released hover
    self.onReleaseHover()
  end
  
  if self.hold and not wb then
    self.hold = false uare.holdt = self
  elseif not self.hold and wb and uare.holdt == self then
    self.hold = true uare.holdt = nil
  end
  
end

function uare:draw()
  
  love.graphics.setColor(((self.hold and self.holdColor) and self.holdColor) or ((self.hover and self.hoverColor) and self.hoverColor) or self.color)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  
  if self.border and self.border.color and self.border.size then
    love.graphics.setColor(((self.hold and self.border.holdColor) and self.border.holdColor) or ((self.hover and self.border.hoverColor) and self.border.hoverColor) or self.border.color)
    love.graphics.setLineWidth(self.border.size)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
  end
  
  if self.text and self.text.display and self.text.color then
    love.graphics.setColor(((self.hold and self.text.holdColor) and self.text.holdColor) or ((self.hover and self.text.hoverColor) and self.text.hoverColor) or self.text.color)
    love.graphics.setFont(self.text.font)
    love.graphics.printf(self.text.display, self.x+self.text.offset.x, self.y+self.height*.5+self.text.offset.y, self.width, self.text.align)
  end
  
end

function uare:remove()
  
  for i = #uare.buttons, 1, -1 do
    if uare.buttons[i] == self then table.remove(uare.buttons, i) self = nil end
  end
  
end

function uare:style(style)
  mergeTables(self, copyTable(style), false)
  
  return self
end

function uare.updateUI(dt, x, y)
  if x and y then
    local e, c = "n", love.mouse.isDown("l")
    if uare.c and not c then
      uare.c = false e = "r" uare.holdt = nil
    elseif not uare.c and c then
      uare.c = true e = "c" uare.holdt = nil
    end
    for i = 1, #uare.buttons do if uare.buttons[i] then uare.buttons[i]:update(dt, x, y, e) end end
  end
end

function uare.drawUI()
  for i = 1, #uare.buttons do uare.buttons[i]:draw() end
end

function uare.clearUI()
  for i = 1, #uare.buttons do uare.buttons[i] = nil end
end

return uare