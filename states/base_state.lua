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

 self.key = "base"

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

-- Returns the next state based on input. Returns a State table.
function BaseState:input(self)
 if Inputs:jump() then
  local on_floor = map_collision(self.player:bottom_outer())
  local space_above = not map_collision(self.player:top_outer())
  if on_floor and space_above then
   return JumpState
  end
 end

 if Inputs:left() or Inputs:right() then
  return WalkState
 else
  return IdleState
 end
end

function BaseState:update(self)
 local on_floor = map_collision(self.player:bottom_outer())
 if not on_floor then
  self.player:set_state(FallState)
 end
end

-- Returns the next state based on physics.
--
-- May also modify the player's physics properties as necessary.
function BaseState:update_physics()
end
