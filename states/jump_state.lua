JumpState = {}
JumpState.__index = JumpState

JumpState.key = "jump"

function JumpState:new(player, animation_name)
 local self = setmetatable({}, JumpState)

 self.player = player
 self.animation_name = animation_name or ""
 self.sprites = {4}

 self.jump_force = -3

 return self
end

function JumpState:can_enter()
 local on_floor = map_collision(self.player:bottom_outer())
 local space_above = not map_collision(self.player:top_outer())
 return on_floor and space_above
end

function JumpState:enter()
 if self.player and self.player.animations then
  self.player.animations:play(self.animation_name)
 end

 self.player.velocity.y = self.jump_force
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
 BaseState.update_physics(self)
end
