Player = {}
Player.__index = Player

function Player:new()
 local self = setmetatable({}, Player)

 self.x = 52
 self.y = 32

 self.h = 8
 self.w = 8
 self.px = 0

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
 return { x = self.x + self.w / 2, y = self.y + self.h - 1 }
end

-- Returns the bottom inner points of the player for collision detection
function Player:bottom_inner()
 return {
  self:bottom_left(),
  self:bottom_right()
 }
end

function Player:bottom_left()
 return { x = self.x + self.px, y = self.y + self.h - 1 }
end

function Player:bottom_right()
 return { x = self.x + (self.w - self.px) - 1, y = self.y + self.h - 1 }
end

-- Returns the bottom outer points of the player for collision detection
function Player:bottom_outer()
 return {
  { x = self.x + self.px, y = self.y + self.h },
  { x = self.x + (self.w - self.px) - 1, y = self.y + self.h }
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

function Player:explode()
 for n = 1,20 do
  Particle:spawn(
   player:bottom_center(),
   flr(rnd(2)),
   8,
   rnd(0.5),
   rnd() * 2 - 1 + player.velocity.x * 0.5,
   rnd() * -1 + player.velocity.y * 0.5
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

function Player:left_outer()
 return {
  {x = self.x + self.px - 1, y = self.y },
  {x = self.x + self.px - 1, y = self.y + self.h - 1 }
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

function Player:right_outer()
 return {
  {x = self.x + (self.w - self.px), y = self.y },
  {x = self.x + (self.w - self.px), y = self.y + self.h - 1}
 }
end

function Player:top_left()
 return { x = self.x + self.px, y = self.y }
end

-- Returns the bottom outer points of the player for collision detection
function Player:top_outer()
 return {
  { x = self.x + self.px, y = self.y - 1 },
  { x = self.x + (self.w - self.px) - 1, y = self.y - 1 }
 }
end

function Player:top_right()
 return { x = self.x + (self.w - self.px) - 1, y = self.y }
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
