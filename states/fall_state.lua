FallState = {}
FallState.__index = FallState

FallState.key = "fall"

function FallState:new(player, animation_name)
 local self = setmetatable({}, FallState)

 self.player = player
 self.animation_name = animation_name or ""
 self.sprites = {5}

 self.coyote_time = 0.125

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
 -- No operation
end

function FallState:input(event)
 if Inputs:jump() then
  local coyote_time_available = false
  if (self.player.last_on_floor_at) then
    local time_since_last_on_floor = time() - (self.player.last_on_floor_at)
    coyote_time_available = time_since_last_on_floor < self.coyote_time
  end
  if coyote_time_available and not map_collision(self.player:top_outer()) then
   return JumpState
  else
   return self
  end
 else
  return self
 end
end

function FallState:update()
 if self.player.is_on_floor then
  self.player:set_state(IdleState)
 else
  local candidate_velocity = {
   x = self.player.velocity.x,
   y = self.player.velocity.y + self.player.gravity
  }
  self.player.velocity = candidate_velocity
 end
end

function FallState:update_physics()
end
