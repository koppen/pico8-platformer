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
