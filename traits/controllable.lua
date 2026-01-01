Controllable = {}
Controllable.__index = Controllable

-- Make the object controllable by player inputs
--
-- object: The object to apply the Controllable effect to. Must have a `velocity` and a
-- `dir` property.
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

 self.object.dir = dir
 self.object.velocity.x = move_x * self.object.speed
end
