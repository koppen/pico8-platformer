function init()
 particles = {}

 shake = {
  duration = 0,
  magnitude = 0
 }
end

function update()
 if player then
  player:update()
 else
  if no_player_since then
   if (time() - no_player_since) > 1 then
    no_player_since = nil
    -- Respawn logic could go here
    player = Player.new()
   end
  else
   no_player_since = time()
  end
 end

 for p in all(particles) do
  p:update()
  if p:is_dead() then
   del(particles, p)
  end
 end
end

function draw()
 cls()

 if shake.duration > 0 then
  screen_x = rnd(shake.magnitude)
  screen_y = rnd(shake.magnitude)

  shake.duration -= 0.016 -- assuming 60 FPS
 else
  screen_x = 0
  screen_y = 0

  shake.magnitude = 0
 end

 map(0,0, screen_x, screen_y)

 if player then
  player:draw()
 end

 for p in all(particles) do
  p:draw()
 end
end

function die()
 if player then
  shake = {
   duration = 0.5,
   magnitude = 2
  }

  player:explode()
  player = nil
 end
end
