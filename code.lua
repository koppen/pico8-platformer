function init()
 player = Player.new()
end

function update()
 player:inputs()
 player:update()
 player:update_physics()
end

function draw()
 cls()

 map(0,0)

 player:draw()
end
