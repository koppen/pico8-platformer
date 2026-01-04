-- Returns true if any of the given points collide with solid tiles
function map_collision(points)
 for point in all(points) do
  local tile_x = flr(point.x / 8)
  local tile_y = flr(point.y / 8)

  local tile = mget(tile_x, tile_y)

  -- Tile flag 0 is solid or not
  local flag = fget(tile, 0)
  if flag then
   return true
  end
 end

 return false
end

-- Detects collisions along the object's trajectory.
--
-- Returns collided, last_free_position
--
-- object: The object to check for collisions. Must have `x`, `y`, and
-- `velocity` properties.
--
-- candidate_velocity: A candidate velocity to check the trajectory for.
function map_horizontal_trajectory_collision(object, candidate_velocity)
 local original_x = object.x
 local original_y = object.y

 local dir = sgn(candidate_velocity.x)

 -- Generate trajectory points for collision detection
 local trajectory	= {}
 for cx = original_x, original_x + candidate_velocity.x, dir do
  add(trajectory, { x = cx, y = object.y})
 end
 -- Add the final position to the trajectory
 add(trajectory, { x = original_x + candidate_velocity.x, y = object.y})

 local collided = nil
 local free_position = { x = original_x, y = original_y }
 for point in all(trajectory) do
  -- Tentatively move the object to the point
  object.x = point.x
  -- object.y = point.y
  collided = map_collision(object:inner())
  if collided then
   printh("Horizontal Collision at: " .. point.x .. "," .. point.y)
   break
  else
   printh("No horizontal collision at: " .. point.x .. "," .. point.y)
   free_position = { x = point.x, y = point.y }
  end
 end

 -- Restore original position
 object.x = original_x
 object.y = original_y

 return collided, free_position
end

function map_vertical_trajectory_collision(object, candidate_velocity)
 local original_x = object.x
 local original_y = object.y

 local dir = sgn(candidate_velocity.y)

 -- Generate trajectory points for collision detection
 local trajectory	= {}
 for cy = original_y, original_y + candidate_velocity.y, dir do
  add(trajectory, { x = object.x, y = cy})
 end
 -- Add the final position to the trajectory
 add(trajectory, { x = object.x, y = original_y + candidate_velocity.y})

 local collided = nil
 local free_position = { x = original_x, y = original_y }
 for point in all(trajectory) do
  -- Tentatively move the object to the point
  -- object.x = point.x
  object.y = point.y
  collided = map_collision(object:inner())
  if collided then
   break
  else
   free_position = { x = point.x, y = point.y }
  end
 end

 -- Restore original position
 object.x = original_x
 object.y = original_y

 return collided, free_position
end
