Inputs = {}
Inputs.__index = Inputs

Inputs.Map = {
 left = 0,
 right = 1,
 up = 2,
 down = 3,
 jump = 4,
 action = 5
}

function Inputs:left()
 return btn(Inputs.Map.left)
end

function Inputs:right()
 return btn(Inputs.Map.right)
end
