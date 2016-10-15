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

local uare = {name = "Uare", elements = {}, z = 1, hz = nil}
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

local function lerp(a, b, k)
  if a == b then return a else
    if math.abs(a-b) < 0.005 then return b else return a * (1-k) + b * k end
  end
end

-- Public methods

function uare.new(t, f)

  if not f then f = t t = "button" end

  local uareObj = f
  setmetatable(uareObj, uare)

  uareObj.hover, uareObj.click = false, false
  
  uareObj.active = f.active or true
  
  uareObj.drag = f.drag or {enabled = false}
  
  uareObj.visible, uareObj.vAlpha = f.visible or true, 1
  
  if uareObj.content then
    if not uareObj.content.scroll then uareObj.content.scroll = {x = 0, y = 0} end
    uareObj.content.width, uareObj.content.height = uareObj.content.width or uareObj.width, uareObj.content.height or uareObj.height
  end
  
  uareObj.type, uareObj.z = t, uare.z
  
  uare.z = uare.z + 1 uare.hz = uare.z --index stuff

  table.insert(uare.elements, uareObj)
  
  return uareObj
end

function uare.newButton(f) return uare.new("button", f) end
  
function uare.newStyle(f) return f end

function uare.newIcon(f) return f end

function uare.newGroup() local t = {type = "group", elements = {}} setmetatable(t, uare) return t end

--
-- Update
--

function uare:updateSelf(dt, mx, my, e)
  
  local alphaTarget = self.visible and 1 or 0
  if self.vAlpha ~= alphaTarget then
    self.vAlpha = lerp(self.vAlpha, alphaTarget, self.l or .2)
  end
  
  local mlc = e ~= "s" and love.mouse.isDown(1) or false
  
  local rwb = withinBounds(mx, my, self.x, self.y, self.x+self.width, self.y+self.height)
  if self.center then
    rwb = withinBounds(mx, my, self.x-self.width*.5, self.y-self.height*.5, self.x+self.width*.5, self.y+self.height*.5)
  end
  
  local wb = e ~= "s" and rwb or false
  
  local thover, thold = self.hover, self.hold
  
  self.hover = wb or (self.drag.enabled and uare.holdt and uare.holdt.obj == self)
  
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
  
  if self.hold and (not wb or self.drag.enabled) and not uare.holdt then
    self.hold = self.drag.enabled uare.holdt = {obj = self, d = {x = self.x-mx, y = self.y-my}}
  elseif not self.hold and wb and (uare.holdt and uare.holdt.obj == self) then
    self.hold = true uare.holdt = nil
  end
  
  if uare.holdt and uare.holdt.obj == self and self.drag.enabled then --drag
    self.x = (not self.drag.fixed or not self.drag.fixed.x) and mx + uare.holdt.d.x or self.x
    self.y = (not self.drag.fixed or not self.drag.fixed.y) and my + uare.holdt.d.y or self.y
    if self.drag.bounds then
      if self.drag.bounds[1] then
        self.x = (self.drag.bounds[1].x and self.x < self.drag.bounds[1].x) and self.drag.bounds[1].x or self.x
        self.y = (self.drag.bounds[1].y and self.y < self.drag.bounds[1].y) and self.drag.bounds[1].y or self.y
      end
      if self.drag.bounds[2] then
        self.x = (self.drag.bounds[2].x and self.x > self.drag.bounds[2].x) and self.drag.bounds[2].x or self.x
        self.y = (self.drag.bounds[2].y and self.y > self.drag.bounds[2].y) and self.drag.bounds[2].y or self.y
      end
    end
    if self.track then
      self:anchor(self.track.ref)
    end
  end
  
  return wb
  
end

function uare:updateTrack(dt)
  
  if self.track then
    
    self.x, self.y = self.track.ref.x + self.track.d.x, self.track.ref.y + self.track.d.y
    
  end
  
end

--
-- Draw
--

function uare:drawSelf()
  
  local tempX, tempY = self.x, self.y
  if self.center then tempX, tempY = self.x-self.width*.5, self.y-self.height*.5 end
  
  love.graphics.setColor(self:alphaColor(((self.hold and self.holdColor) and self.holdColor) or ((self.hover and self.hoverColor) and self.hoverColor) or self.color))
  love.graphics.rectangle("fill", tempX, tempY, self.width, self.height)
  
  if self.border and self.border.color and self.border.size then
    love.graphics.setColor(self:alphaColor(((self.hold and self.border.holdColor) and self.border.holdColor) or ((self.hover and self.border.hoverColor) and self.border.hoverColor) or self.border.color))
    love.graphics.setLineWidth(self.border.size)
    love.graphics.rectangle("line", tempX, tempY, self.width, self.height)
  end
  
  if self.icon and self.icon.source.type and self.icon.source.content then
    love.graphics.setColor(self:alphaColor(((self.hold and self.icon.holdColor) and self.icon.holdColor) or ((self.hover and self.icon.hoverColor) and self.icon.hoverColor) or self.icon.color))
    love.graphics.push()
    local offset = self.icon.offset or {x = 0, y = 0}
    love.graphics.translate((tempX+(self.center and 0 or self.width*.5)+offset.x), (tempY+(self.center and 0 or self.height*.5)+offset.y))
    if self.icon.source.type == "polygon" then
      for i = 1, #self.icon.source.content do
        love.graphics.polygon("fill", self.icon.source.content[i])
      end
    elseif self.icon.source.type == "image" then
      love.graphics.draw(self.icon.source.content, 0, 0)
    end
    love.graphics.pop()
  end
  
  if self.text and self.text.display and self.text.color then
    love.graphics.setColor(self:alphaColor(((self.hold and self.text.holdColor) and self.text.holdColor) or ((self.hover and self.text.hoverColor) and self.text.hoverColor) or self.text.color))
    love.graphics.setFont(self.text.font)
    local offset = self.text.offset or {x = 0, y = 0}
    love.graphics.printf(self.text.display, self.x-(self.center and self.width*.5 or 0)+offset.x, self.y+(self.center and 0 or self.height*.5)+offset.y, self.width, self.text.align)
  end
  
  if self.content and self.drawContent then
    self:renderContent()
  end
  
end

--
-- Content
--

function uare:renderContent()
  love.graphics.push()
  local tx, ty = self.x, self.y
  if self.center then tx, ty = self.x-self.width*.5, self.y-self.height*.5 end
  love.graphics.translate(tx-self.content.scroll.x*(self.content.width-self.width), ty-self.content.scroll.y*(self.content.height-self.height))
  if self.content and self.content.wrap then love.graphics.setScissor(tx, ty, self.width, self.height) end
  self.drawContent(self, self.vAlpha*255)
  if self.content and self.content.wrap then love.graphics.setScissor() end
  love.graphics.pop()
end

function uare:setContent(f)
  self.drawContent = f
end

function uare:setContentDimensions(w, h)
  if self.content then
    self.content.width, self.content.height = w, h
  end
end

function uare:setScroll(f)
  f.x = f.x or 0
  f.y = f.y or 0
  if self.content then 
    f.x = (f.x < 0 and 0) or (f.x > 1 and 1) or f.x
    f.y = (f.y < 0 and 0) or (f.y > 1 and 1) or f.y
    self.content.scroll.x, self.content.scroll.y = f.x or self.content.scroll.x, f.y or self.content.scroll.y
  end
end

function uare:getScroll()
  if self.content then 
    return { x = self.content.scroll.x, y = self.content.scroll.y }
  end
end

--
-- Miscellaneous
--

function uare.update(dt, x, y)

  if x and y then
    local e, c = "n", love.mouse.isDown(1)
    if uare.c and not c then
      uare.c = false e = "r" uare.holdt = nil
    elseif not uare.c and c then
      uare.c = true e = "c" uare.holdt = nil
    end
    --update every button/window first...
    local focused = false
    
    local updateQueue = {}
  
    for i = 1, #uare.elements do table.insert(updateQueue, uare.elements[i]) end
    
    table.sort(updateQueue, function(a, b) return a.z > b.z end)

    for i = 1, #updateQueue do
      local elemt = updateQueue[i]
      if elemt then
        if elemt:updateSelf(dt, x, y, ((focused or (uare.holdt and uare.holdt.obj ~= elemt)) or not elemt.active) and "s" or e) then
          focused = true
        end
      end
    end
    --...then update their anchors
    for i = #uare.elements, 1, -1 do
      if uare.elements[i] then
        uare.elements[i]:updateTrack(dt)
      end
    end
  end
end

function uare.draw()
  local drawQueue = {}
  
  for i = 1, #uare.elements do if uare.elements[i].draw then table.insert(drawQueue, uare.elements[i]) end end
  
  table.sort(drawQueue, function(a, b) return a.z < b.z end)
  
  for i = 1, #drawQueue do drawQueue[i]:drawSelf() end
end

--
-- Methods
--

--Creation / Linking

function uare:style(style)
  mergeTables(self, copyTable(style), false)
  
  return self
end

function uare:anchor(other)
  self.track = {ref = other, d = {x = self.x-other.x, y = self.y-other.y}}
  
  return self
end

function uare:group(group)
  table.insert(group.elements, self)
  
  return self
end

--Active

function uare:setActive(bool)
  if self.type == "group" then
    for i = 1, #self.elements do
      self.elements[i]:setActive(bool)
    end
  else
    self.active = bool
  end
end

function uare:enable() return self:setActive(true) end

function uare:disable() return self:setActive(false) end

function uare:getActive() if self.active ~= nil then return self.active end end

--Visible

function uare:setVisible(bool, l) --l is for lerp
  
  if self.type == "group" then
    for i = 1, #self.elements do
      self.elements[i]:setVisible(bool, l)
    end
  else
    self.visible = bool
    self.l = l
    if not l or l == 0 then self.vAlpha = bool and 1 or 0 end
  end
  
end

function uare:show(l) return self:setVisible(true, l) end

function uare:hide(l) return self:setVisible(false, l) end
  
function uare:getVisible() if self.visible ~= nil then return self.visible end end
  
--Drag

function uare:setDragBounds(bounds)
  self.drag.bounds = bounds
end

function uare:setHorizontalRange(n)
  self.x = self.drag.bounds[1].x + (self.drag.bounds[2].x-self.drag.bounds[1].x)*n
end

function uare:setVerticalRange(n)
  self.y = self.drag.bounds[1].y + (self.drag.bounds[2].y-self.drag.bounds[1].y)*n
end

function uare:getHorizontalRange()
  assert(self.drag.bounds and self.drag.bounds[1] and self.drag.bounds[2] and self.drag.bounds[1].x and self.drag.bounds[2].x, "Element must have 2 horizontal boundaries")
  return (self.x-self.drag.bounds[1].x) / (self.drag.bounds[2].x-self.drag.bounds[1].x)
end

function uare:getVerticalRange()
  assert(self.drag.bounds and self.drag.bounds[1] and self.drag.bounds[2] and self.drag.bounds[1].y and self.drag.bounds[2].y, "Element must have 2 vertical boundaries")
  return (self.y-self.drag.bounds[1].y) / (self.drag.bounds[2].y-self.drag.bounds[1].y)
end

--Z-Index  

function uare:setIndex(index)
  
  if self.type == "group" then
    local lowest
    for i = 1, #self.elements do
      if not lowest or self.elements[i].z < lowest then lowest = self.elements[i].z end
    end
    for i = 1, #self.elements do
      local ti = self.elements[i].z-lowest+index
      self.elements[i]:setIndex(ti)
    end
  else
    self.z = index
    if index > uare.hz then uare.hz = index end
  end
  
end

function uare:toFront()
  if self.z < uare.hz or self.type == "group" then return self:setIndex(uare.hz + 1) end
end

function uare:getIndex() return self.z end

function uare:alphaColor(col)
  return {col[1], col[2], col[3], col[4] and col[4]*self.vAlpha or self.vAlpha*255}
end

function uare:remove()
  
  for i = #uare.elements, 1, -1 do
    if uare.elements[i] == self then table.remove(uare.elements, i) self = nil end
  end
  
end

function uare.clear()
  for i = 1, #uare.elements do uare.elements[i] = nil end
end

return uare
