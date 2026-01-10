JumpState = {}
JumpState.__index = JumpState

JumpState.key = "jump"

function JumpState:new(player, animation_name)
 local self = setmetatable({}, JumpState)

 self.player = player
 self.animation_name = animation_name or ""
 self.sprites = {4}

 self.coyote_time = 0.2
 self.jump_force = -1.9

 -- How long the player can hold the jump button to continue jumping
 self.jump_time_window = 0.16

 return self
end

function JumpState:enter()
 if self.player and self.player.animations then
  self.player.animations:play(self.animation_name)
 end

 self.entered_at = time()

 self.player.velocity.y = self.jump_force
 self.player.coyote_time_available = false

 for n = 1,4 do
  Particle:spawn(
   self.player.x + 4,
   self.player.y + 8,
   flr(rnd(2)),
   7,
   rnd(0.25),
   rnd() * 1 - 0.5,
   rnd() * 0.05 - 0.1
  )
 end

 for n = 1,8 do
  Particle:spawn(
  self.player.x + 4,
  self.player.y + 8,
  flr(rnd(1)),
  7,
  rnd(0.25),
  rnd() * 0.05 - 0.1,
  rnd() * -0.5 - 0.25
  )
 end
end

function JumpState:exit()
 -- No operation
end

function JumpState:input(event)
 if Inputs:jump() and (time() < self.entered_at + self.jump_time_window) then
  self.player.velocity.y = self.jump_force
 end

 if self.player.velocity.y < 0 then
  return self
 else
  return FallState
 end
end

function JumpState:update()
 -- No operation
end

function JumpState:update_physics()
  local gravity_modifier = 1
  -- Hangtime
  if (self.player.velocity.y > -1) and (self.player.velocity.y < -0.1) then
   gravity_modifier = -self.player.velocity.y / 0.725
  end

 local candidate_velocity = {
  x = self.player.velocity.x,
  y = self.player.velocity.y + self.player.gravity * gravity_modifier
 }

 collided, free_position = map_trajectory_collision(self.player, candidate_velocity)
 if collided then
  self.player.velocity.y = 0
 else
  self.player.velocity = candidate_velocity
 end
end
