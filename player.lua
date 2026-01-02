Player = {}
Player.__index = Player

function Player:new()
 local self = setmetatable({}, Player)

 self.x = 52
 self.y = 32

 self.gravity = 0.2
 self.speed = 1
 self.velocity = { x = 0, y = 0 }

 -- Sprite
 self.s = 1

 -- Initials
 self.dir = 0

 self.traits = {
  Controllable:new(self),
  Fall:new(self)
 }

 return self
end

-- Returns the bottom inner points of the player for collision detection
function Player:bottom_inner()
 return {
  self:bottom_left(),
  self:bottom_right()
 }
end

function Player:bottom_left()
 return { x = self.x, y = self.y + 7 }
end

function Player:bottom_right()
 return { x = self.x + 7, y = self.y + 7 }
end

-- Returns the bottom outer points of the player for collision detection
function Player:bottom_outer()
 return {
  { x = self.x, y = self.y + 8 },
  { x = self.x + 7, y = self.y + 8 }
 }
end

function Player:draw()
 local flip_x = self.dir == -1
 spr(self.s, self.x, self.y, 1, 1, flip_x)
end

-- Returns the inner corner points of the player for collision detection
function Player:inner()
 return {
  self:bottom_left(),
  self:bottom_right(),
  self:top_left(),
  self:top_right()
 }
end

function Player:top_left()
 return { x = self.x, y = self.y }
end

function Player:top_right()
 return { x = self.x + 7, y = self.y }
end

function Player:update()
 -- Process traits
 for trait in all(self.traits) do
  trait:update()
 end
end
