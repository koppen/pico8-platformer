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

 return self
end

function Controllable:update()
 local dir = self.object.dir
 local move_x = 0
 local move_y = 0

 if Inputs:left() then
  dir = -1
  move_x -= 1
 elseif Inputs:right() then
  dir = 1
  move_x += 1
 end

 -- Perform preliminary collision checks, does it even make sense to move in that direction?
 if dir < 0 and (map_collision(self.object:left_outer())) then
  move_x = 0
 end
 if dir > 0 and (map_collision(self.object:right_outer())) then
  move_x = 0
 end

 self.object.dir = dir
 self.object.velocity.x = move_x
end
