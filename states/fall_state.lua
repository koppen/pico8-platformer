FallState = {}
FallState.__index = FallState

FallState.key = "fall"

function FallState:new(player, animation_name)
 local self = setmetatable({}, FallState)

 self.player = player
 self.animation_name = animation_name or ""
 self.sprites = {5}

 self.coyote_time = 0.05

 return self
end

function FallState:enter(old_state)
 if self.player and self.player.animations then
  self.player.animations:play(self.animation_name)
 end

 self.entered_at = time()
 self.entered_from = old_state
end

function FallState:exit()
 if self.player.velocity.y > 1 then
  shake.duration = 0.2
  shake.magnitude = self.player.velocity.y * 0.25
 end
end

function FallState:input(event)
 if Inputs:jump() and self.player.coyote_time_available and not map_collision(self.player:top_outer()) then
  return JumpState
 else
  return self
 end
end

function FallState:update()
 if self.player.coyote_time_available and (time() - self.entered_at > self.coyote_time) then
  self.player.coyote_time_available = false
 end

 if self.player.is_on_floor then
  self.player:set_state(IdleState)
 else
  local gravity_modifier = 1.25
  if (self.player.velocity.y > 0) and (self.player.velocity.y < 1) then
   -- Hangtime
   gravity_modifier = self.player.velocity.y / 0.725
  end
  local candidate_velocity = {
   x = self.player.velocity.x,
   y = self.player.velocity.y + self.player.gravity * gravity_modifier
  }
  self.player.velocity = candidate_velocity
 end
end

function FallState:update_physics()
end
