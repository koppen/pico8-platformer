Jump = {}
Jump.__index = Jump

-- Let's an object jump
function Jump:new(object)
 local self = setmetatable({}, Jump)

 self.object = object
 self.jump_force = -3

 return self
end

function Jump:update()
 if Inputs:jump() then
  local on_floor = map_collision(self.object:bottom_outer())
  if on_floor then
   self.object.velocity.y = self.jump_force
  end
 end
end
