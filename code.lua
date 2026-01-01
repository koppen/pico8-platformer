function init()
 player = Player.new()
end

function update()
 player:update()
end

function draw()
 cls()

 map(0,0)

 player:draw()
end
