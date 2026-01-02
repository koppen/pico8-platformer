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

 self.object.dir = dir

 -- Verify the movement doesn't collide with the map
 local original_x = self.object.x
 local candidate_velocity = {
  x = move_x * self.object.speed,
  y = self.object.velocity.y
 }

 -- Generate horizontal trajectory points for collision detection
 local trajectory	= {}
 for cx = original_x, original_x + candidate_velocity.x, dir do
  add(trajectory, { x = cx, y = self.object.y})
 end
 -- Add the final position to the trajectory
 add(trajectory, { x = self.object.x + candidate_velocity.x, y = self.object.y})

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
  -- Collided, stop moving
  self.object.velocity.x = 0

  -- Move to last free position
  if free_position then
   self.object.x = free_position.x
  end
 else
  -- Commit the current velocity
  self.object.velocity = candidate_velocity
 end
end
