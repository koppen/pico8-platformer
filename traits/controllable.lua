Controllable = {}
Controllable.__index = Controllable

-- Make the object controllable by player inputs
--
-- object: The object to apply the Controllable effect to. Must have a
-- `velocity` and a `dir` property.
--
-- After processing the trait the objects x and velocity.x will have been
-- updated according to player inputs.
function Controllable:new(object)
 local self = setmetatable({}, Controllable)

 self.object = object

 self.accelleration = 0.18
 self.friction = 0.9
 self.max_speed = 2

 self.move_x = 0

 return self
end

function Controllable:update()
 local dir = self.object.dir

 if Inputs:left() then
  dir = -1
  self.move_x -= self.accelleration
 elseif Inputs:right() then
  dir = 1
  self.move_x += self.accelleration
 end

 -- Perform preliminary collision checks, does it even make sense to move in that direction?
 if dir < 0 and (map_collision(self.object:left_outer())) then
  self.move_x = 0
 end
 if dir > 0 and (map_collision(self.object:right_outer())) then
  self.move_x = 0
 end

 if self.move_x > self.max_speed then
  self.move_x = self.max_speed
 elseif self.move_x < -self.max_speed then
  self.move_x = -self.max_speed
 end

 self.move_x *= self.friction

 self.object.dir = dir
 self.object.velocity.x = self.move_x
end
