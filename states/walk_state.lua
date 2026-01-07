WalkState = {}
WalkState.__index = WalkState

WalkState.key = "walk"

function WalkState:new(player, animation_name)
 local self = setmetatable({}, WalkState)

 self.player = player
 self.animation_name = animation_name or ""
 self.sprites = {2,3}

 return self
end

function WalkState:enter()
 if self.player and self.player.animations then
  self.player.animations:play(self.animation_name)
 end

 self.player.coyote_time_available = true
end

function WalkState:exit()
 -- No operation
end

function WalkState:input(event)
 return BaseState:input(self, event)
end

function WalkState:update()
 return BaseState:update(self)
end

function WalkState:update_physics()
 BaseState.update_physics(self)
end
