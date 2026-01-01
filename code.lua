function init()
 player = Player.new()
end

function update()
 player:update()
end

function draw()
 cls()

 player:draw()
end
