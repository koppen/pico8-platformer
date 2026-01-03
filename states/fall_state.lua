FallState = {}
FallState.__index = FallState

FallState.key = "fall"

function FallState:new(player, animation_name)
 local self = setmetatable({}, FallState)
 self.player = player
 self.animation_name = animation_name or ""
 return self
end

function FallState:enter()
 if self.player and self.player.animations then
  self.player.animations:play(self.animation_name)
 end
end

function FallState:exit()
 -- No operation
end

function FallState:input(event)
  if self:on_floor() then
    return IdleState
  else
    return self
  end
end

function FallState:on_floor()
  return map_collision(self.player:bottom_outer())
end

function FallState:update()
 -- No operation
end

function FallState:update_physics()
 BaseState.update_physics(self)
end
