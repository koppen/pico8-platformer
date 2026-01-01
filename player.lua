Player = {}
Player.__index = Player

function Player:new()
 local self = setmetatable({}, Player)

 self.x = 32
 self.y = 32

 -- Sprite
 self.s = 1

 -- Initials
 self.dir = 0

 return self
end

function Player:draw()
 local flip_x = self.dir == -1
 spr(self.s, self.x, self.y, 1, 1, flip_x)
end

function Player:update()
 local dir = self.dir
 local move_x = 0
 local move_y = 0

 if Inputs:left() then
  dir = -1
  move_x -= 1
 elseif Inputs:right() then
  dir = 1
  move_x += 1
 end

 -- Commit changes
 self.dir = dir
 self.x += move_x
 self.y += move_y
end
