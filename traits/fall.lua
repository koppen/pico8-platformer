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

-- Applies gravity and movement to the object.
--
-- After the update the objects will have been moved to a valid position.
function Fall:update()
 local candidate_velocity = {
  x = self.object.velocity.x,
  y = self.object.velocity.y + self.object.gravity
 }

 collided, free_position = map_trajectory_collision(self.object, candidate_velocity)

 if collided then
  -- Collided, stop falling
  self.object.velocity.y = 0
  if self.object.velocity.x != 0 then
   self.object:set_state(WalkState)
  else
   self.object:set_state(IdleState)
  end
  -- Move to last free position
  if free_position then
   -- Floor the y coordinate to place the object exactly on the tile
   self.object.y = flr(free_position.y)
  end
 else
  -- Commit the current velocity
  self.object.velocity = candidate_velocity
  self.object.y = self.object.y + candidate_velocity.y
 end
end
