function init()
 player = Player.new()
 particles = {}
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

 map(0,0)

 player:draw()

 for p in all(particles) do
  p:draw()
 end
end
