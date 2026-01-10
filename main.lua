function init()
 player = Player.new()
 particles = {}

 shake = {
  duration = 0,
  magnitude = 0
 }
end

function update()
 player:prepare()
 player:inputs()
 player:update()
 player:update_physics()

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

 player:draw()

 for p in all(particles) do
  p:draw()
 end
end
