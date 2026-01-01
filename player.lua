Player = {}
Player.__index = Player

function Player:new()
 local self = setmetatable({}, Player)

 self.x = 32
 self.y = 32

 -- Sprite
 self.s = 1

 return self
end

function Player:draw()
 spr(self.s, self.x, self.y)
end

function Player:update()
 if Inputs:left() then
  self.x -= 1
 elseif Inputs:right() then
  self.x += 1
 end
end
