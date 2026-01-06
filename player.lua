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
  -- Fall:new(self),
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

function Player:left_outer()
 return {
  {x = self.x - 1, y = self.y },
  {x = self.x - 1, y = self.y + 7 }
 }
end

-- Analyze and prepare the player before updating
function Player:prepare()
 self.is_on_floor = map_collision(self:bottom_outer())
 if self.is_on_floor then
  self.last_on_floor_at = time()
 end
end

function Player:set_state(state)
 local old_state = self.state
 if state and state.key and state.key != old_state.key then
  local new_state = state:new(self)
   printh("[set_state] Transitioning from " .. old_state.key .. " to " .. new_state.key)
   old_state:exit()
   self.state = new_state
   self.state:enter()
 end
end

function Player:right_outer()
 return {
  {x = self.x + 7 + 1, y = self.y },
  {x = self.x + 7 + 1, y = self.y + 7 }
 }
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

-- Process actions and state updates
function Player:update()
 self.state:update()

 -- Process traits
 for trait in all(self.traits) do
  trait:update()
 end
end

-- Update the player's physics (position and velocity)
function Player:update_physics()
 if self.state.update_physics then
  local s = self.state:update_physics()
  self:set_state(s)
 end

 -- At this point the velocity is a suggestion/wish
 -- Checking for horizontal collisions...
 local collided_x, free_position_x = map_trajectory_collision(self, {x = self.velocity.x, y = 0})
 if collided_x then
  self.x = free_position_x.x
  self.y = free_position_x.y
 else
  self.x += self.velocity.x
 end

 -- Checking for vertical collisions...
 local collided_y, free_position_y = map_trajectory_collision(self, {x = 0, y = self.velocity.y})
 if collided_y then
  self.x = free_position_y.x
  self.y = free_position_y.y
 else
  self.y += self.velocity.y
 end

 -- Detect stuckness!
 if map_collision(self:inner()) then
  printh("PLAYER STUCK AT: " .. self.x .. "," .. self.y)
  stop()  -- Crash the program to investigate
 end
end
