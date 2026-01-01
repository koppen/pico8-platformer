Fall = {}
Fall.__index = Fall

-- Applies a falling effect to the object
--
-- object: The object to apply the fall effect to. Must have a `velocity` and a
-- `gravity` property.
function Fall:new(object)
 local self = setmetatable({}, Fall)

 self.object = object

 return self
end

function Fall:update()
 -- Apply gravity
 self.object.velocity.y += self.object.gravity

 if self.object:on_floor() then
  self.object.velocity.y = 0
 end
end
