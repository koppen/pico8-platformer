Player = {}
Player.__index = Player

function Player:new()
 local self = setmetatable({}, Player)

 self.x = 52
 self.y = 32

 -- Physics
 self.gravity = 0.2
 self.speed = 1
 self.velocity = { x = 0, y = 0 }

 -- Sprite
 self.s = 1

 -- Internals
 self.dir = 0

 -- What can the player do?
 self.traits = {
  Controllable:new(self),
  Fall:new(self),
 }

 -- States
 self.state = IdleState:new(self)

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
 local sprites = self.state.sprites
 local sprite_index = flr((time() * 4) % #sprites) + 1
 local sprite = sprites[sprite_index]
 spr(sprite, self.x, self.y, 1, 1, flip_x)

 if self.state then
  print(self.state.key, 0, 0)
 end
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

function Player:inputs()
 local new_state = self.state:input()
 self:set_state(new_state)
end

function Player:set_state(state)
 local old_state = self.state
 if state and state.key and state.key != old_state.key then
  local new_state = state:new(self)
  if new_state:can_enter() then
   printh("[set_state] Transitioning from " .. old_state.key .. " to " .. new_state.key)
   old_state:exit()
   self.state = new_state
   self.state:enter()
  end
 end
end

function Player:top_left()
 return { x = self.x, y = self.y }
end

-- Returns the bottom outer points of the player for collision detection
function Player:top_outer()
 return {
  { x = self.x, y = self.y - 1 },
  { x = self.x + 7, y = self.y - 1 }
 }
end

function Player:top_right()
 return { x = self.x + 7, y = self.y }
end

-- Update the player's physics (position and velocity)
function Player:update_physics()
 -- Process traits
 for trait in all(self.traits) do
  trait:update()
 end

 if self.state.update_physics then
  local s = self.state:update_physics()
  self:set_state(s)
 end
end
