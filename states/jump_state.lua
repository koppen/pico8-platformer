JumpState = {}
JumpState.__index = JumpState

JumpState.key = "jump"

function JumpState:new(player, animation_name)
 local self = setmetatable({}, JumpState)

 self.player = player
 self.animation_name = animation_name or ""
 self.sprites = {4}

 self.coyote_time = 0.2
 self.jump_force = -3

 return self
end

function JumpState:enter()
 if self.player and self.player.animations then
  self.player.animations:play(self.animation_name)
 end

 self.player.velocity.y = self.jump_force
 self.player.coyote_time_available = false
end

function JumpState:exit()
 -- No operation
end

function JumpState:input(event)
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
 local candidate_velocity = {
  x = self.player.velocity.x,
  y = self.player.velocity.y + self.player.gravity * 0.7
 }

 collided, free_position = map_trajectory_collision(self.player, candidate_velocity)
 if collided then
  self.player.velocity.y = 0
 else
  self.player.velocity = candidate_velocity
 end
end
