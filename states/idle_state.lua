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

 self.player.coyote_time_available = true
end

function IdleState:exit()
 -- No operation
end

function IdleState:input(event)
 return BaseState:input(self, event)
end

function IdleState:update()
 self.player.x = flr(self.player.x)
 self.player.y = flr(self.player.y)
 self.player.velocity.x = 0
 self.player.velocity.y = 0

 return BaseState:update(self)
end

function IdleState:update_physics()
 BaseState.update_physics(self)
end
