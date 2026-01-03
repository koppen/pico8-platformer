IdleState = {}
IdleState.__index = IdleState

IdleState.key = "idle"

function IdleState:new(player, animation_name)
 local self = setmetatable({}, IdleState)

 self.player = player
 self.animation_name = animation_name or ""
 self.sprites = {1,2}

 return self
end

function IdleState:enter()
 if self.player and self.player.animations then
  self.player.animations:play(self.animation_name)
 end
end

function IdleState:exit()
 -- No operation
end

function IdleState:input(event)
 return BaseState:input(self, event)
end

function IdleState:update()
 -- No operation
end

function IdleState:update_physics()
 BaseState.update_physics(self)
end
