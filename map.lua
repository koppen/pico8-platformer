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
function map_trajectory_collision(object, candidate_velocity)
 local original_x = object.x
 local original_y = object.y
 local end_x = original_x + candidate_velocity.x
 local end_y = original_y + candidate_velocity.y

 local collided = nil
 local free_position = { x = original_x, y = original_y }

 local vx = candidate_velocity.x
 local vy = candidate_velocity.y
 local steps = max(4, ceil(max(abs(vx), abs(vy))))
 local dx = (vx / steps)
 local dy = (vy / steps)
 local point = {x = end_x, y = end_y}

 for step = 1, steps do
  object.x = point.x
  object.y = point.y

  -- printh("CONSIDERING point: " .. object.x .. "," .. object.y .. " (step " .. step .. " of " .. steps .. ") Remain: vx=" .. vx .. ", vy=" .. vy .. " dx=" .. dx .. ", dy=" .. dy)

  collision = map_collision(object:inner())
  if collision then
   collided = true

   -- Move to an earlier position to find the last free position
   point.x -= dx
   point.y -= dy
  else
   -- This is the free position closest to the collision
   free_position = { x = object.x, y = object.y }
   break
  end

  vx = vx - dx
  vy = vy - dy
 end

 -- Restore original position
 object.x = original_x
 object.y = original_y

 return collided, free_position
end
