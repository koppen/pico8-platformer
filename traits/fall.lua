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
 local original_y = self.object.y

 local candidate_velocity = {
  x = self.object.velocity.x,
  y = self.object.velocity.y + self.object.gravity
 }
 local dir = sgn(candidate_velocity.y)

 -- Generate trajectory points for collision detection
 local trajectory	= {}
 for cy = original_y, original_y + candidate_velocity.y, dir do
  add(trajectory, { x = self.object.x, y = cy})
 end
 -- Add the final position to the trajectory
 add(trajectory, { x = self.object.x, y = original_y + candidate_velocity.y})

 local collided = nil
 local free_position = nil
 for point in all(trajectory) do
  -- Tentatively move the object to the point
  self.object.x = point.x
  self.object.y = point.y
  collided = map_collision(self.object:inner())
  if collided then
   break
  else
   free_position = { x = point.x, y = point.y }
  end
 end

 if collided then
  -- Collided, stop falling
  self.object.velocity.y = 0

  -- Move to last free position
  if free_position then
   -- Floor the y coordinate to place the object exactly on the tile
   self.object.y = flr(free_position.y)
  end
 else
  -- Commit the current velocity
  self.object.velocity = candidate_velocity
 end
end
