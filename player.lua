Player = {}
Player.__index = Player

function Player:new()
 local self = setmetatable({}, Player)

 self.x = 52
 self.y = 32

 self.hit = {
  x = 1,
  y = 0,
  w = 6,
  h = 8
 }

 -- Physics
 self.gravity = 0.2
 self.speed = 1
 self.velocity = { x = 0, y = 0 }

 -- Sprite
 self.s = 1

 -- Internals
 self.dir = 0
 self.jumps_available = 0
 self.max_jumps = 2

 -- What can the player do?
 self.traits = {
  Controllable:new(self),
  -- Fall:new(self),
 }

 -- States
 self.state = IdleState:new(self)

 return self
end

function Player:bottom_center()
 return { x = self:left_x() + self.hit.w / 2, y = self:bottom_y() }

end

function Player:bottom_left()
 return { x = self:left_x(), y = self:bottom_y() }
end

function Player:bottom_right()
 return { x = self:right_x(), y = self:bottom_y() }
end

-- Returns the bottom outer points of the player for collision detection
function Player:bottom_outer()
 return {
  { x = self:left_x(), y = self.y + self.hit.y + self.hit.h },
  { x = self:right_x(), y = self.y + self.hit.y + self.hit.h }
 }
end

-- Returns the y coordinate of the bottom of the player
function Player:bottom_y()
 return self.y + self.hit.y + self.hit.h - 1
end

function Player:draw()
 local flip_x = self.dir == -1
 local sprites = self.state.sprites
 local sprite_index = flr((time() * 4) % #sprites) + 1
 local sprite = sprites[sprite_index]

 spr(sprite, self.x, self.y, 1, 1, flip_x)
end

function Player:explode()
 for n = 1,20 do
  Particle:spawn(
   player:bottom_center(),
   flr(rnd(2)),
   8,
   rnd(1.5),
   rnd() * 2 - 1 + player.velocity.x * 0.5,
   rnd() * -1 + player.velocity.y * 0.5,
   self.gravity / 4
  )
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

-- Returns the x coordinate of the left of the player
function Player:left_x()
 return self.x + self.hit.x
end

function Player:left_outer()
 return {
  {x = self:left_x() - 1, y = self:top_y() },
  {x = self:left_x() - 1, y = self:bottom_y() }
 }
end

-- Analyze and prepare the player before updating
function Player:prepare()
 self.is_on_floor = map_collision(self:bottom_outer())

 if not Inputs:jump() then
  self.jump_available = true
 end
end

function Player:set_state(state)
 local old_state = self.state
 if state and state.key and state.key != old_state.key then
  local new_state = state:new(self)
   printh("[set_state] Transitioning from " .. old_state.key .. " to " .. new_state.key)
   old_state:exit()
   self.state = new_state
   self.state:enter(old_state)
 end
end

-- Returns the x coordinate of the right of the player
function Player:right_x()
 return self.x + self.hit.x + self.hit.w - 1
end

function Player:right_outer()
 return {
  {x = self:right_x() + 1, y = self:top_y() },
  {x = self:right_x() + 1, y = self:bottom_y() }
 }
end

-- Returns the y coordinate of the top of the player
function Player:top_y()
 return self.y + self.hit.y
end

function Player:top_left()
 return { x = self:left_x(), y = self:top_y() }
end

-- Returns the top outer points of the player for collision detection
function Player:top_outer()
 return {
  { x = self:left_x(), y = self:top_y() - 1 },
  { x = self:right_x(), y = self:top_y() - 1 }
 }
end

function Player:top_right()
 return { x = self:right_x(), y = self:top_y() }
end

-- Process actions and state updates
function Player:process_actions()
 self.state:update()

 -- Process traits
 for trait in all(self.traits) do
  trait:update()
 end
end

function Player:update()
 self:prepare()
 self:inputs()
 self:process_actions()
 self:update_physics()

 for tile in all(map_tiles_at(self:inner())) do
  -- Tile flag 1 is deadly or not
  local flag = fget(tile, 1)
  if flag then
   die()
  end
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
