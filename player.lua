Player = {}
Player.__index = Player

function Player:new()
 local self = setmetatable({}, Player)

 self.x = 32
 self.y = 32

 self.gravity = 0.1
 self.speed = 1
 self.velocity = { x = 0, y = 0 }

 -- Sprite
 self.s = 1

 -- Initials
 self.dir = 0

 self.traits = {
  Fall:new(self)
 }

 return self
end

function Player:draw()
 local flip_x = self.dir == -1
 spr(self.s, self.x, self.y, 1, 1, flip_x)
end

function Player:on_floor()
 return self.y >= 100
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

 self.velocity.x = move_x * self.speed

 -- Process traits
 for trait in all(self.traits) do
  trait:update()
 end

 -- Commit changes
 self.dir = dir
 self.x += self.velocity.x
 self.y += self.velocity.y
end
