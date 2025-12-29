-- Based on ShaggyDevs state machine
-- https://shaggydev.com/2022/02/13/advanced-state-machines-godot/

BaseState = {}
BaseState.__index = BaseState

-- Enum for State
BaseState.State = {
 Null = 0,
 Idle = 1,
 Walk = 2,
 Fall = 3,
 Jump = 4
}

function BaseState:new(player, animation_name)
 local self = setmetatable({}, BaseState)
 self.player = player
 self.animation_name = animation_name or ""
 return self
end

function BaseState:enter()
 if self.player and self.player.animations then
  self.player.animations:play(self.animation_name)
 end
end

function BaseState:exit()
 -- No operation
end

function BaseState:input(event)
 return BaseState.State.Null
end

function BaseState:process(delta)
 return BaseState.State.Null
end

function BaseState:physics_process(delta)
 return BaseState.State.Null
end

print "base_state"
